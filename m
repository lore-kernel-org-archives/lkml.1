Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbZDFOoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbZDFOoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZDFOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:43:59 -0400
Received: from hermes.mlbassoc.com ([76.76.67.137]:3307 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZDFOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:43:58 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 10:43:58 EDT
Message-ID: <49DA12C7.9000900@mlbassoc.com>
Date: Mon, 06 Apr 2009 08:33:43 -0600
From: Gary Thomas <gary@mlbassoc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] spi_mpc83xx: Handles other Freescale processors
References: <20090404192802.GA12183@oksana.dev.rtsoft.ru> <6758B03E-2525-4754-83FA-643CED277CC6@kernel.crashing.org>
In-Reply-To: <6758B03E-2525-4754-83FA-643CED277CC6@kernel.crashing.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Apr 4, 2009, at 2:28 PM, Anton Vorontsov wrote:
> 
>> With this patch we'll able to select spi_mpc83xx driver on the MPC86xx
>> platforms. Let the driver depend on FSL_SOC, so we don't have to worry
>> about Kconfig anymore.
>>
>> Also remove the "experimental" dependency, the driver has been tested
>> to work on a various hardware, and surely not experimental anymore.
>>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>> ---
>> drivers/spi/Kconfig |   14 ++++++--------
>> 1 files changed, 6 insertions(+), 8 deletions(-)
> 
> this looks fine, but why don't we go ahead and rename things as well? 
> SPI_MPC83xx -> SPI_MPC8xxx, spi_mpc83xx.c -> spi_mpc8xxx.c

mpc8xxx implies mpc82xx (e.g. mpc8272) which is not the same controller
as on the mpc83xx

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
