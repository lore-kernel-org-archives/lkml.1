Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXFUTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXFUTmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXFUTme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:42:34 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:47270 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbXFUTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:42:33 -0400
Date: Thu, 21 Jun 2007 15:42:28 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Lars Marowsky-Bree <lmb@suse.de>
cc: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070621192407.GF20105@marowsky-bree.de>
Message-ID: <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
References: <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com>
 <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com>
 <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com>
 <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
 <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Lars Marowsky-Bree wrote:

> A veto is not a technical argument. All technical arguments (except for
> "path name is ugly, yuk yuk!") have been addressed, have they not?

AppArmor doesn't actually provide confinement, because it only operates on 
filesystem objects.

What you define in AppArmor policy does _not_ reflect the actual 
confinement properties of the policy.  Applications can simply use other 
mechanisms to access objects, and the policy is effectively meaningless.

You might define this as a non-technical issue, but the fact that AppArmor 
simply does not and can not work is a fairly significant consideration, I 
would imagine.



- James
-- 
James Morris
<jmorris@namei.org>
