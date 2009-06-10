Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZFJJVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZFJJVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZFJJU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:20:59 -0400
Received: from customer-relay.songnetworks.se ([195.42.210.9]:49585 "EHLO
	customer-relay.songnetworks.se" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbZFJJU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:20:58 -0400
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2009 05:20:58 EDT
Message-ID: <4A2F737A.2000407@mocean-labs.com>
Date: Wed, 10 Jun 2009 10:48:58 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2/9] SPI: xilinx_spi: Added platform driver and support
 for DS570
References: <4A292043.70704@mocean-labs.com> <20090609160954.ae0bda8e.akpm@linux-foundation.org>
In-Reply-To: <20090609160954.ae0bda8e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-06-10 01.09, Andrew Morton wrote:
> On Fri, 05 Jun 2009 15:40:19 +0200
> Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:
> 
>> This patch splits xilinx_spi into three parts, an OF and a platform
>> driver and generic part.
>>
>> The generic part now also works on X86 and also supports the Xilinx
>> SPI IP DS570
> 
> Unfortunately we already have two fairly significant
> drivers/spi/xilinx_spi.c patches queued in -mm:
> spi-move-more-spi_setup-functionality-into-core.patch and
> spi-move-common-spi_setup-functionality-into-core.patch.  Applying this
> patch on top of those makes rather a mess.
> 
> Hopefully things will still be OK if I skip this patch.  You didn't
> identify the dependencies between those nine patchs.  Can you please
> explain that?

Actually all patches except for the 7th(of 9), would work without the
xilinx_spi-patch.
The 7th (Timberdale MFD) would not build. Some of the othe drivers are not
possible to select because they depend on the MFD in their Kconfigs,
but not the code.

I would be very happy if you applied all but the 7th (MFD) and 2nd (SPI) anyway.

I will update my SPI-patch to work against the two patches you point out above.
And them I will resend the Timberdale MFD and the Xilinx SPI patch.

Would that be OK?

--Richard
