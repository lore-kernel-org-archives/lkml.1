Return-Path: <linux-kernel-owner+w=401wt.eu-S1423298AbXBHTtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423298AbXBHTtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423288AbXBHTs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:48:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:34288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423290AbXBHTso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:48:44 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-acpi@vger.kernel.org
Subject: Re: [git patches] IDE updates for 2.6.20
Date: Thu, 8 Feb 2007 14:47:06 -0500
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070207180814.27444.59159.sendpatchset@localhost.localdomain> <20070207182748.1c0c3588@localhost.localdomain> <45CA1916.6020709@ru.mvista.com>
In-Reply-To: <45CA1916.6020709@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702081447.07223.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 13:23, Sergei Shtylyov wrote:
> Hello.
> 
> Alan wrote:
> > On Wed, 07 Feb 2007 19:08:14 +0100
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> >>- ACPI support for IDE (has been in SuSE kernels for months)
> >>  (Hannes Reinecke <hare@suse.de>)
> 
> > I can find no public copy of this or discussion of it, please post a
> 
> http://marc.theaimsgroup.com/?l=linux-ide&m=116916643921306
> 
> > reference to the previous discussion or put the ACPI patch somewhere for
> > review first.
> 
> http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/ide-acpi-support.patch

So it looks like...
if (CONFIG_BLK_DEV_IDEACPI=y)
	suspend uses _GTM
	resume uses _STM

But it looks like _GTF and using the task file is disabled by default,
and needs to be enabled by invoking "ide=acpigtf".  Why is that?

Also, what's the story on ide=acpionboot -- when/why is that expected
to be invoked, and why is it not the default?

thanks,
-Len
