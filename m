Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZADUV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZADUV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZADUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:21:18 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43589
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZADUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:21:17 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Vrabel <david.vrabel@csr.com>
Subject: Re: PATCH [1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh (v2)
Date: Sun, 4 Jan 2009 14:21:13 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031927.07670.rob@landley.net> <49602375.6020409@csr.com>
In-Reply-To: <49602375.6020409@csr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041421.13920.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 20:48:21 David Vrabel wrote:
> Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Replace kernel/timeconst.pl with kernel/timeconst.sh.  The new shell
> > script is much simpler, about 1/4 the size, and runs on Red Hat 9 from
> > 2003.
> >
> > It requires a shell which can do 64 bit math, such as bash, busybox ash,
> > or dash running on a 64 bit host.
>
> I use Ubuntu (hence dash) on 32 bit systems so I think this needs to
> work with dash on 32 bit hosts.

I have a qemu/images directory full of various OS images for testing purposes.

I just fired up my jeos 7.10 image to make sure that even the most stripped-
down version of Ubuntu ("just enough operating system) still installs bash by 
default, and it does.  (It doesn't install a development toolchain, but it 
does install bash.)

I also installed a 32 bit xubuntu 8.10 image (which took 4 hours for some 
reason, and which also has bash), and explicitly tested its 32-bit 
"/bin/dash", and that did 64-bit math too.  So current versions of dash do 
offer 64 bit math on 32 bit platforms.

> David

Rob
