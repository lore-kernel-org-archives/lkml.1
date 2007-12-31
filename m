Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXLaSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXLaSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbXLaSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:01:14 -0500
Received: from lilly.ping.de ([83.97.42.2]:4715 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751133AbXLaSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:01:13 -0500
Date: Mon, 31 Dec 2007 18:43:02 +0100
From: Patrick Mau <mau@oscar.ping.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Bodo Eggert <7eggert@gmx.de>, Adrian Bunk <bunk@kernel.org>,
       devzero@web.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20071231174302.GA1627@oscar.prima.de>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz> <20071231122419.GA13803@does.not.exist> <alpine.LSU.0.999.0712311335210.3761@be1.lrz> <20071231144255.GB13803@does.not.exist> <alpine.LSU.0.999.0712311553530.4211@be1.lrz> <Pine.LNX.4.64.0712311628330.28123@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712311628330.28123@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 04:34:55PM +0100, Jan Engelhardt wrote:
> >
> >If you'd aim for a small kernel image, you would build anything as a module 
> >that is not requred for booting.
> >
> Yes, there is a tradeoff for both.
> 
> Example:
> 16:30 ichi:../net/802 > l fc.o fc.ko 
> -rw-r--r-- 1 jengelh users 7961 Dec 27 15:19 fc.ko
> -rw-r--r-- 1 jengelh users 2453 Dec 28 23:58 fc.o
> (from a recent not-so-complete patch turning CONFIG_FC etc. into =m)
> 
> If fc was modular, it might save the 2453 bytes off the core kernel image,
> but adds ~5508 bytes to disk.
> So one has to pick =y or =m depending on whatever suits his/her situation.

May I ask something that might be obvious for most of the
development community:

Modules have to be loaded in seperate pages, right ?

Does that mean that each module wastes partially used
pages of memory at runtime ?

I've always tried to build as much into the kernel image as
possible, because all of my systems have only 512M memory.

Thanks,
Patrick

