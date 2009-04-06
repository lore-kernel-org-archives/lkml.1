Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbZDFOj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbZDFOj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZDFOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:39:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:36928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbZDFOjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:39:46 -0400
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Message-Id: <7450FD1B-9C81-4C98-8A81-63999892A3A4@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Gary Thomas <gary@mlbassoc.com>
In-Reply-To: <49DA12C7.9000900@mlbassoc.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 1/3] spi_mpc83xx: Handles other Freescale processors
Date: Mon, 6 Apr 2009 09:36:33 -0500
References: <20090404192802.GA12183@oksana.dev.rtsoft.ru> <6758B03E-2525-4754-83FA-643CED277CC6@kernel.crashing.org> <49DA12C7.9000900@mlbassoc.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6, 2009, at 9:33 AM, Gary Thomas wrote:

> Kumar Gala wrote:
>>
>> On Apr 4, 2009, at 2:28 PM, Anton Vorontsov wrote:
>>
>>> With this patch we'll able to select spi_mpc83xx driver on the  
>>> MPC86xx
>>> platforms. Let the driver depend on FSL_SOC, so we don't have to  
>>> worry
>>> about Kconfig anymore.
>>>
>>> Also remove the "experimental" dependency, the driver has been  
>>> tested
>>> to work on a various hardware, and surely not experimental anymore.
>>>
>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>>> ---
>>> drivers/spi/Kconfig |   14 ++++++--------
>>> 1 files changed, 6 insertions(+), 8 deletions(-)
>>
>> this looks fine, but why don't we go ahead and rename things as well?
>> SPI_MPC83xx -> SPI_MPC8xxx, spi_mpc83xx.c -> spi_mpc8xxx.c
>
> mpc8xxx implies mpc82xx (e.g. mpc8272) which is not the same  
> controller
> as on the mpc83xx

True, but normally the 82xx drivers are "cpm" prefixed.  I think 8xxx  
is at better name than 83xx.

- k
