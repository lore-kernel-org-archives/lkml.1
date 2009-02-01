Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZBATHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZBATHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZBATHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:07:04 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:47925 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZBATHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:07:02 -0500
Message-ID: <4985F284.4030400@free.fr>
Date: Sun, 01 Feb 2009 20:05:40 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 Iceape/1.1.14 (Debian-1.1.14-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Philippe De Muyter <phdm@macqel.be>
Subject: Re: [BUG] pnpbios breaks floppy support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I should have added that, when started with pnpbios enabled, 
> I have found the following in /sys/devices/pnp0/ :
> 
> 	$ cat 00:03/id
> 	PNP0700
> 	$ cat 00:03/resources 
> 	state = active
> 	io 0x3f4-0x3f5
> 	io 0x3f2-0x3f2
> 	irq 6
> 	dma 2
> 	$ cat 00:03/options
> 	port 0x3f4-0x3f4, align 0x0, size 0x2, 16-bit address decoding
> 	port 0x3f2-0x3f2, align 0x0, size 0x1, 16-bit address decoding
> 	irq 6 High-Edge
> 	dma 2 8-bit compatible

And what is on "cat 00:07/resources" ?
I bet you also found the floppy IO here...


Matthieu
