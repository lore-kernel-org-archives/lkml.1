Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYIARTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYIARTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYIARS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:18:59 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:53766 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYIARS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:18:59 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=sS3GAUUIs2MqLpdRdCMA:9 a=brx8iGYHZR89iB5QLLX_tYtvkd0A:4
Message-ID: <48BC2405.9070403@shaw.ca>
Date: Mon, 01 Sep 2008 11:19:01 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mtrr madness
References: <fa.oAfJTOqZ/UBF74k5hFotOE73/z4@ifi.uio.no>
In-Reply-To: <fa.oAfJTOqZ/UBF74k5hFotOE73/z4@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> it seems that all linux kernels contain a bug with mtrr:
> 
>  cat /proc/mtrr 
> reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=197120MB: write-back, count=1
> reg02: base=0x9fc00000 (2556MB), size=196612MB: uncachable, count=1
> reg03: base=0x100000000 (4096MB), size=200704MB: write-back, count=1
> reg04: base=0x200000000 (8192MB), size=204800MB: write-back, count=1
> 
> (watch the size)
> 
> it is definitely  present in the kernels 2.6.16, 2.6.24, 2.6.25, 2.6.26.
> 
> 198656 is 0x3080000000, the correct value would be 0x80000000, similarly
> 197120 is 0x3020000000, the correct would be 0x20000000. 

Those are set up by the BIOS, so it would be what's at fault. I think we 
may be adding something to fix this up though?
