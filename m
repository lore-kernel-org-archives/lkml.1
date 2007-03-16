Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXCPIKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXCPIKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXCPIKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:10:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:60585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXCPIKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:10:31 -0400
Message-ID: <45FA50E4.60006@suse.de>
Date: Fri, 16 Mar 2007 09:10:12 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
References: <20070315154638.944768000@suse.de> <17913.45970.178029.519745@smtp.charter.net>
In-Reply-To: <17913.45970.178029.519745@smtp.charter.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> Would this explain why recent version of GDM don't find the keyboard
> properly when you boot with a kernel command line of:
> 
>    kernel ... console=tty0 console=ttyS1,96008N1
> 
> until you stop and restart GDM?

No.  If you explicitly specify the console on the kernel command line
you get what you ask for, no matter whenever you apply the patch or not.

With the args above /dev/console is linked to /dev/ttyS1, which might
make gpm fail.  Would be a gpm bug though.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
