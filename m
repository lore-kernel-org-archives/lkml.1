Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0CBBMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:12:42 -0500
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:39847 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0CBBMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:12:40 -0500
From: Kevin Wells <kevin.wells@nxp.com>
To: Luotao Fu <l.fu@pengutronix.de>
CC: Vitaly Wool <vitalywool@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       Ben Dooks <ben-linux@fluff.org>, Julia Lawall <julia@diku.dk>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Mar 2010 02:12:05 +0100
Subject: RE: [PATCH] i2c-pnx: fix setting start/stop condition
Thread-Topic: [PATCH] i2c-pnx: fix setting start/stop condition
Thread-Index: Acq5dC9MHGCnQsjZRIqZFTmq3ZtaQwALjZ2Q
Message-ID: <083DF309106F364B939360100EC290F805CCF929E1@eu1rdcrdc1wx030.exi.nxp.com>
References: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
 <083DF309106F364B939360100EC290F805CCF9294A@eu1rdcrdc1wx030.exi.nxp.com>
 <20100301191954.GA1811@pengutronix.de>
In-Reply-To: <20100301191954.GA1811@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166 definitions=2010-03-01_17:2010-02-06,2010-03-01,2010-03-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Luotao,

> 
> I had a closer look into this and think that you are right. I was
> irritated by the unregular usage of start_bit and thought the stop bit is
> asserted with the i2c_pnx_stop call, which is apparently only used for
> zero sized transfers.
> 
> Fixed patch is attached with this mail.
> 

This latest patch seems to work fine and tests well with all our
I2C devices - including the pcf8563, which didn't work right before
this patch. I think it's good to go.

thanks!
Kevin

> cheers
> Luotao Fu
> --
> Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
