Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZAWTuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZAWTuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZAWTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:50:07 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:63340 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751091AbZAWTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:50:06 -0500
Date: Fri, 23 Jan 2009 22:49:58 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH resend 0/6] OpenFirmware support for the spi_mpc83xx driver
Message-ID: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081205200936.GA19137@oksana.dev.rtsoft.ru> <6DC0606C-1CDA-4549-8A63-E3F86010291B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <6DC0606C-1CDA-4549-8A63-E3F86010291B@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:28:10PM -0600, Kumar Gala wrote:
> On Dec 5, 2008, at 2:09 PM, Anton Vorontsov wrote:
>> Hi all,
>>
>> The patch series are used to support SPI via the OF SPI subsystem
>> (driver/of/of_spi.c). Now the driver is able to manage its own
>> chip selects, and doesn't need any auxiliary support from the
>> board files or fsl_soc constructors.
>>
>> The series also contains PowerPC portions of the MMC SPI support.
>>
>> Since the series touches spi and powerpc trees, I think it would
>> be most convenient to pass it via one of these trees. The patches
>> doesn't touch any SPI functionality, only some probe routines, so
>> I believe powerpc.git is the best candidate...
>>
>> The other reason for powerpc tree is that the patches depends on
>> other patches as found in paulus/powerpc.git + of_gpio_count()
>> as found here:
>> http://ozlabs.org/pipermail/linuxppc-dev/2008-December/065917.html
>>
>> David, if you're OK with the patches, may I ask you to sign off on
>> the ones that touch drivers/spi so that we could pass it via Kumar's
>> powerpc.git?
>>
>> The queue:
>>
>> [1/7] powerpc: Implement get_brgfreq() and get_baudrate() stubs
>> [2/7] spi_mpc83xx: Fix sparse warnings
>> [3/7] spi_mpc83xx: Rework chip selects handling
>> [4/7] spi_mpc83xx: Add OF platform driver bindings
>> [5/7] powerpc/fsl_soc: Isolate legacy fsl_spi support to mpc832x_rdb  
>> boards
>> [6/7] powerpc: Add mmc-spi-slot bindings
>> [7/7] powerpc/83xx: Add mmc-spi support via the device tree for  
>> MPC8323E-RDB
>>
>
> David,
>
> Any status on these patches?

Ping? No single comment on this patch set for ~2 months...

Resending...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
