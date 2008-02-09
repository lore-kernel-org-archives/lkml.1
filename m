Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYBIJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYBIJ0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYBIJ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:26:20 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYBIJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:26:18 -0500
Message-ID: <47AD71B3.5070906@free-electrons.com>
Date: Sat, 09 Feb 2008 10:26:11 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some	processors
References: <200802082347.25364.michael-lists@free-electrons.com> <1202512812.17934.680.camel@cinder.waste.org>
In-Reply-To: <1202512812.17934.680.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2008 12:20 AM, Matt Mackall wrote:
> Please include the output of size with all these options on and off.
>   
Oops, here they are:

Standard kernel (original config: make allnoconfig + CONFIG_EMBEDDED):
> size vmlinux
   text    data     bss     dec     hex filename
 966473  139000   90112 1195585  123e41 vmlinux

Size of vmlinux: 1386005

With the patch (using only CONFIG_CPU_SUP_INTEL):
> size vmlinux
   text    data     bss     dec     hex filename
 957561  136536   90112 1184209  1211d1 vmlinux
(-9812) (-2464)

Size of vmlinux: 1373697 (-12308 bytes)

-12K in the kernel size looks quite nice to me.

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

