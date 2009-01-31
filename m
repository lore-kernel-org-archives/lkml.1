Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZAaUpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZAaUpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZAaUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:45:26 -0500
Received: from fifo99.com ([67.223.236.141]:33344 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZAaUpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:45:25 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 15:45:25 EST
Subject: Re: [PATCH] net: variables reach -1, but 0 tested
From: Daniel Walker <dwalker@fifo99.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <498429AE.1080404@gmail.com>
References: <498429AE.1080404@gmail.com>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 12:35:12 -0800
Message-Id: <1233434112.5903.28.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 11:36 +0100, Roel Kluin wrote:

>  
> -	while (limit--) {
> +	while (--limit) {
>  		val = phy_read(phy, MII_BMCR);
>  		if (val >= 0 && (val & BMCR_RESET) == 0)
>  			break;

It looks like these are checked for <= to 0 , are these changes strictly
nessesary?

>  
>  	/* make sure EEPROM has finished loading before setting GPIO_CFG */
>  	timeout=1000;
> -	while ( timeout-- && (SMC_GET_E2P_CMD(lp) & E2P_CMD_EPC_BUSY_)) {
> +	while ( --timeout && (SMC_GET_E2P_CMD(lp) & E2P_CMD_EPC_BUSY_)) {
>  		udelay(10);

If your doing "timeOut" to "timeout" below may as well drop the space
above after the "(" ..


Daniel

