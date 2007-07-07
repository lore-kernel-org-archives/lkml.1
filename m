Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXGGVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXGGVks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXGGVkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:40:41 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54682 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXGGVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:40:40 -0400
Message-ID: <46900851.4060403@gmail.com>
Date: Sat, 07 Jul 2007 23:40:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>	<20070706111848.43551f33@the-village.bc.nu> <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2007 02:30 PM, Christoph Pleger wrote:

> And what about hdparm (setting 32bit I/O and multi-sector mode)? Suren 
> wrote that 32bit I/O makes no sense when using DMA. Maybe that's right, 
> but it does not correspond with my experiences. At least, I have the 
> "feeling" that my IDE disks work much faster since I enabled 32bit 
> support (DMA already was on before).

hdparm -t /dev/hda (or /dev/sda -- it works for the SD interface as well) is 
a quick test of a drive's sequential read speed.

I have, at the time, noticed at least on older controllers/drives (Intel 430 
generation chipsets with things like 8G UDMA33 disks) that I could reliably 
increase the result with something like 1MB/s (to a total of 6 to 8, so it 
wasn't insignificant) by enabling 32-bit I/O. Had also understood that it 
shouldn't make a difference with DMA, but just went "oh well" and stuck a 
"hdparm -c1" in my bootup scripts.

(if anyone tries; note that hdparm -a can have a large effect on that result 
as well on some setups -- on machines where it does, -a 1024 usually gives 
me best results)

Rene.
