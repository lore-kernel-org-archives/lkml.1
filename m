Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbXIVXvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbXIVXvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIVXvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:51:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27656 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXIVXvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BA98keKmLYALbTuJZdxbfsOeo1ooAzyQQrgUoIsordhBx29Kv7k6RDQfpF5MFzRZiGgEo65yZkR4MnoWPCqdzLI9EhoRarQrs+DEcdf2x0RDHzMk7RLjjRpWjSYahHQVC0Wgbnz3eMiJVi/MdW0B2XsFxHXcFt0pbd52Sox3D/0=
Subject: Re: VGA text console display problem with kernel 2.6.23-rc5/6
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: lnx-kern@soo.com
Cc: Kernel Mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <46F21280.6040400@soo.com>
References: <46EF7DAD.3080502@soo.com> <1190105055.6446.2.camel@daplas>
	 <46F21280.6040400@soo.com>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 07:51:30 +0800
Message-Id: <1190505090.11468.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 02:26 -0400, ben soo wrote:
> Antonino A. Daplas wrote:
> > On Tue, 2007-09-18 at 03:26 -0400, ben soo wrote:
> >> i've 2 servers with old PCI VGA cards, one using X86_64 kernel 
> >> version 2.6.23-rc5 and one with i386 kernel version 2.6.23-rc6,
> >> both wired into the same CRT via a KVM switch.
> > 
> > Is this new? If yes, what's the version of the last working kernel?
> 
> Hi Antonio; i'm very sorry about the delay in answering: been 
> pretty ill.
> 

That's okay.

> i had upgraded all four servers here to 2.6.23-rc6 and found that 
> only one had this console problem.  It runs a very old S3 Virge
> PCI vidcard.
> 
> Tonight i upgraded it to 2.6.23-rc7 and the console is fine again, 
> but, just to be complete i include the requested info:
> 
>   > Can you post dmesg and output of stty -a?
> 
> stty -a
> 
> speed 38400 baud; rows 34; columns 80; line = 0;

Yes, you have an 80x34 screen (normal VGA is 80x25). I have received
several reports about this problem (if the kernel boots with an initial
screen which is not 80x25 and the init scripts attempts to set an 8x16
font, the user gets a display that does not fit the screen). Your
problem though is probably unrelated.

Tony


