Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZHZFus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZHZFus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZHZFur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:50:47 -0400
Received: from iona.labri.fr ([147.210.8.143]:58678 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbZHZFuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:50:46 -0400
X-Greylist: delayed 1147 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 01:50:46 EDT
Message-ID: <4A94C8DF.4030406@inria.fr>
Date: Wed, 26 Aug 2009 07:32:15 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to get a DMA channel near a process?
References: <4A93E192.9000109@inria.fr> <4A94C5B6.3060907@gmail.com>
In-Reply-To: <4A94C5B6.3060907@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 08/25/2009 07:05 AM, Brice Goglin wrote:
>> Hello,
>>
>> I am playing with DMA engine on a Nehalem box with two X58 chipsets
>> (Supermicro X8DAH). My understanding is that there are 8 DMA channels on
>> each chipset, so 8 channels near each processor. Unfortunately, my BIOS
>
> Don't think that DMA channel is the term you are looking for, maybe
> PCI Express lanes? DMA channels are an ancient ISA thing.

Talking about DMA Engine devices/channels such as Intel I/OAT. See
include/linux/dmaengine.h

Brice

