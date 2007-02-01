Return-Path: <linux-kernel-owner+w=401wt.eu-S1422929AbXBASml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422929AbXBASml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422933AbXBASml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:42:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422929AbXBASmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:42:40 -0500
Date: Thu, 1 Feb 2007 10:42:17 -0800
From: Judith Lebzelter <judith@osdl.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Judith Lebzelter <judith@osdl.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, fastboot@osdl.org
Subject: Re: [ PATCH ] fix to documentation for kexec
Message-ID: <20070201184217.GF5825@shell0.pdx.osdl.net>
References: <20070201181955.GE5825@shell0.pdx.osdl.net> <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0702011932090.13737@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702011932090.13737@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 07:33:58PM +0100, Jan Engelhardt wrote:
> 
> On Feb 1 2007 13:30, Robert P. J. Day wrote:
> >> >@@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
> >> > * You must specify <root-dev> in the format corresponding to the root
> >> >   device name in the output of mount command.
> >> >
> >> >-* "init 1" boots the dump-capture kernel into single-user mode without
> >> >-  networking. If you want networking, use "init 3."
> >> >+* Boot parameter "1" boots the dump-capture kernel into single-user mode
> >> >+  without networking. If you want networking, use "3".
> >>
> >> Yup. More precisely, any arguments that could not be parsed (because
> >> the kernel does not know them) are handed down to the init program
> >> as arguments and/or environment variables.
> >
> >whoops, ignore my last post, i misread the critical words.
> 
> However, I am not sure how the kernel will handle this. Especially since:
> 
>   * if you boot with no initramfs, init= is handled by your script
>     (otherwise: kernel)
> 
>   * does "init" qualify as a kernel param already? I don't think so,
>     since the code indicates to be wanting "init=" at least.
> 
> Either way, the word "init" in the above doc is either (1) wrong
> or (2) superfluous [unless something strange happens to interpret it later,
> which I don't think]

Yes, it looks like "init=" is right, "init" is wrong.

I did notice that my patch is out of date for the latest kernel, 
however.  I can send an up to date one.

Judith
> 
> 
> Jan
> -- 
> ft: http://freshmeat.net/p/chaostables/
