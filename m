Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbXHDVEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbXHDVEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbXHDVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:04:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:15428 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765235AbXHDVET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AWnAV9XiSr31C5X6JRi+POg6oU7D21zYfuFUZS+mA+p63xPjHX8kx+k6ZSFDbo/RTfiz/aoqK6GpkU2fIBZSHd7tm5LncXX3WYKKvexEegetUnZnFWGTe5oDUReTKVAvoKIUv5d3lHstV/sEMALlIR2K4XFKvI6xsWFFvpxv8aA=
Subject: Re: Linux 2.6.23-rc2
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46B4C011.8090802@zytor.com>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
	 <46B4C011.8090802@zytor.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 05:02:13 +0800
Message-Id: <1186261333.5079.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 11:06 -0700, H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > On Sat, 4 Aug 2007, Jeff Chua wrote:
> >> On 8/4/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> >>>> After resume from s2ram or switching to console from X, my console is
> >>>> messed up on rc1 and rc2. Is there a fix for this?
> >>> This is on IBM X60. i915 chipset. No problem on 2.6.22. If this is a
> >>> known problem, than I don't need to bisect all over again.
> >> I managed to bisect down to this commit. Without this, console screen
> >> can resume without video mess.
> > 
> > [ The commit being 4fd06960f120e02e9abc802a09f9511c400042a5: "Use the new 
> >   x86 setup code for i386" ]
> > 
> > Very interesting. 
> > 
> > Jeff - do I understand correctly that the "or" means that even *without* a 
> > suspend-to-ram sequence, and just by going into X and then going back to 
> > text-mode, the screen is corrupt?
> 
> Also, can you please describe "messed up" in more detail?  We had one
> report of "screen messed up" already that did get fixed
> (CONFIG_FIRMWARE_EDID not working.)

I believe this is the case where VBE DDC reading is non-contributory.

> 
> Are you using the VGA console or a framebuffer console?
> 
> Also, please submit your .config and kernel command line.

The dmesg output, the X logs and the s2ram options will also be useful.

Tony


