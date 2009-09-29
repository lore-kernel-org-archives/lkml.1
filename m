Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZI2Qqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZI2Qqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZI2Qqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:46:46 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:65071 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZI2Qqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:46:45 -0400
Subject: Re: [PATCH V2] regulator: add driver for MAX8660/8661
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1253864366-25459-1-git-send-email-w.sang@pengutronix.de>
References: <1253816506.11624.889.camel@vega>
	 <1253864366-25459-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 17:46:44 +0100
Message-Id: <1254242804.6623.312.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 09:39 +0200, Wolfram Sang wrote:
> Tested with a MX25-based custom board.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
> 
> Have fun at LPC! :)
> 
> Changes since V1:
> 
> - dropped comment about forced PWM (superfluous)
> - use list-functions in set-functions
> 
> Changes since RFC:
> 
> - introduced EN34_IS_HIGH option in platform_data
> - documentation moved into the source
> - switched to use ?DTV2-registers instead of ?DTV1
>   (created easier to read bit-patterns, no functional change)
> - added a note that forced PWM does not save power here
> - improved comments & removed typos
> 
>  drivers/regulator/Kconfig         |    7 +
>  drivers/regulator/Makefile        |    1 +
>  drivers/regulator/max8660.c       |  510 +++++++++++++++++++++++++++++++++++++
>  include/linux/regulator/max8660.h |   57 ++++
>  4 files changed, 575 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/max8660.c
>  create mode 100644 include/linux/regulator/max8660.h

Back from LPC and applied to for-next.

Thanks

Liam

