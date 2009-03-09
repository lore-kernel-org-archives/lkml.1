Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZCIQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZCIQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZCIQyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:54:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:43092 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZCIQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:54:44 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-Id: <9F1B582F-B01E-436D-9E46-81C2E4B4E8D0@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH resend 0/6] OpenFirmware support for the spi_mpc83xx driver
Date: Mon, 9 Mar 2009 11:53:17 -0500
References: <20081205200936.GA19137@oksana.dev.rtsoft.ru> <6DC0606C-1CDA-4549-8A63-E3F86010291B@kernel.crashing.org> <20090123194958.GA17355@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2009, at 1:49 PM, Anton Vorontsov wrote:

> On Tue, Jan 06, 2009 at 10:28:10PM -0600, Kumar Gala wrote:
>> On Dec 5, 2008, at 2:09 PM, Anton Vorontsov wrote:
>>> Hi all,
>>>
>>> The patch series are used to support SPI via the OF SPI subsystem
>>> (driver/of/of_spi.c). Now the driver is able to manage its own
>>> chip selects, and doesn't need any auxiliary support from the
>>> board files or fsl_soc constructors.
>>>
>>> The series also contains PowerPC portions of the MMC SPI support.
>>>
>>> Since the series touches spi and powerpc trees, I think it would
>>> be most convenient to pass it via one of these trees. The patches
>>> doesn't touch any SPI functionality, only some probe routines, so
>>> I believe powerpc.git is the best candidate...
>>>
>>> The other reason for powerpc tree is that the patches depends on
>>> other patches as found in paulus/powerpc.git + of_gpio_count()
>>> as found here:
>>> http://ozlabs.org/pipermail/linuxppc-dev/2008-December/065917.html
>>>
>>> David, if you're OK with the patches, may I ask you to sign off on
>>> the ones that touch drivers/spi so that we could pass it via Kumar's
>>> powerpc.git?
>>>
>>> The queue:
>>>
>>> [1/7] powerpc: Implement get_brgfreq() and get_baudrate() stubs
>>> [2/7] spi_mpc83xx: Fix sparse warnings
>>> [3/7] spi_mpc83xx: Rework chip selects handling
>>> [4/7] spi_mpc83xx: Add OF platform driver bindings
>>> [5/7] powerpc/fsl_soc: Isolate legacy fsl_spi support to mpc832x_rdb
>>> boards
>>> [6/7] powerpc: Add mmc-spi-slot bindings
>>> [7/7] powerpc/83xx: Add mmc-spi support via the device tree for
>>> MPC8323E-RDB
>>>
>>
>> David,
>>
>> Any status on these patches?
>
> Ping? No single comment on this patch set for ~2 months...
>
> Resending...
>
> Thanks,

David,

Anything going on here?  Should we send this via some other channel?

- k
