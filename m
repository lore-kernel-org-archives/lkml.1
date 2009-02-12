Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZBLELZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZBLELZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 23:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZBLEK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 23:10:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:3437 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbZBLEK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 23:10:56 -0500
Date: Thu, 12 Feb 2009 15:08:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, sds@tycho.nsa.gov,
       spotter@cs.columbia.edu, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in_execve flag into task_struct.
In-Reply-To: <2690.1233841235@redhat.com>
Message-ID: <alpine.LRH.1.10.0902121504130.18145@tundra.namei.org>
References: <20090107190652.GA20311@us.ibm.com> <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com> <49639039.4060708@cs.columbia.edu> <1231267532.9746.116.camel@localhost.localdomain> <200901070634.n076YCxF061022@www262.sakura.ne.jp>
 <2690.1233841235@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, David Howells wrote:

> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > It's ugly, you can't get me to say it isn't ugly :), and it sets a scary
> > bad precedent.  But if David insists (in a reply to this msg) that this
> > flag really is tops, then just ignore me.  Anyway my point wasn't to
> > block the patch but to raise discussion (so someone else could decide to
> > block it :) on both the flag and security implications of these
> > semantics.
> 
> I think it's probably the best way to support Tomoyo's security model without
> reworking a chunk of execve().

Agreed.  It's somewhat less than perfect, but I don't see a better 
alternative.


- James
-- 
James Morris
<jmorris@namei.org>
