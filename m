Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbXFMWzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbXFMWzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXFMWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:54:54 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:37291 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbXFMWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:54:52 -0400
Date: Wed, 13 Jun 2007 18:54:48 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Toshiharu Harada <haradats@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC] TOMOYO Linux
In-Reply-To: <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
Message-ID: <Line.LNX.4.64.0706131835040.13360@localhost.localdomain>
References: <466FA71C.1020309@nttdata.co.jp>  <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
  <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com> 
 <46704D49.8010308@redhat.com>  <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
  <467064B9.1080005@redhat.com> <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Toshiharu Harada wrote:

> TOMOYO Linux has a mode called "learning"
> in addition to "permissive" and "enforce". You can easily
> get the TOMOYO Linux policy with learning mode that
> SELinux does not have.

Blindly generating security policy through observation of the system is 
potentially dangerous for many reasons.

See
<http://securityblog.org/brindle/2006/03/25/security-anti-pattern-status-quo-encapsulation/>

Note that while SELinux does also have a similar capability with the 
audit2allow tool, it should be considered an expert tool, the output of 
which needs to be understood before use (as noted in its man page).

> In addition, access control mode of
> TOMOYO Linux can be managed for every difference domain.

We have considered per-domain enforcing mode a couple of times in the 
past, but figured that it could be implemented via policy alone (e.g. run 
the task in a domain where all accesses are allowed and logged); and it 
would also be of limited usefulness because of the aforementioned problems 
with learning mode security policy.


- James
-- 
James Morris
<jmorris@namei.org>
