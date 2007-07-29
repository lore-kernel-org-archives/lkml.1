Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXG2OKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXG2OKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762439AbXG2OKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:10:40 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:47779 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762641AbXG2OKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:10:39 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.23-rc1, KVM-AMD problem
Date: Sun, 29 Jul 2007 15:10:31 +0100
User-Agent: KMail/1.9.7
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200707281855.41277.alistair@devzero.co.uk> <200707291444.18024.alistair@devzero.co.uk> <46AC9A8D.8060003@qumranet.com>
In-Reply-To: <46AC9A8D.8060003@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291510.31731.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 14:47:57 you wrote:
> Alistair John Strachan wrote:
> > On Sunday 29 July 2007 12:34:28 you wrote:
> > [snip]
> >
> >>> Doesn't help, I still get the same crashes. I tried 2.6.22 again and
> >>> it's rock solid by comparison.
> >>
> >> Do you mean, kvm-33 on top of 2.6.22, or the kvm modules from 2.6.22?
> >> Please describe your configuration *exactly*.
> >
> > I'm using the kvm-33 *userspace* package (based on Debian's kvm-28
> > packaging) and 2.6.23-rc1's KVM modules. I patched 2.6.23-rc1 with the
> > patch you provided in your last email. So I'm not using -git HEAD.
> >
> > Maybe there's been additional necessary fixes to -git requiring me to
> > update to HEAD? That wasn't clear from your last email.
>
> No,  that patch is the only potential fix post -rc1.  There are a few
> other fixes there, but they are intended to avoid guest crashes, not
> host crashes.
>
> What guest are you running?  Maybe I can reproduce it here.

Right now, Windows XP. I'm pretty sure Linux (well, Debian Etch) works fine. I 
could only get Windows to install with -no-acpi, but I run it with the 
following (if this is at all useful):

kvm -no-acpi -m 256 -hda $IMAGE -net nic -net tap,script=/etc/kvm/kvm-ifup

Basically, the installer seems to work fine, but Windows seemed to have 
problems after installing post-SP2 updates. Maybe that's why not everybody is 
seeing it yet.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

