Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbYJTJq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbYJTJq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYJTJqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:46:22 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60239 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750745AbYJTJqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:46:22 -0400
Date: Mon, 20 Oct 2008 11:46:07 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] Add Dallas DS1390 RTC chip
Message-ID: <20081020114607.1b0299cb@i1501.lan.towertech.it>
In-Reply-To: <48FC442E.9070206@mimc.co.uk>
References: <48FC442E.9070206@mimc.co.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 09:41:18 +0100
Mark Jackson <mpfj@mimc.co.uk> wrote:

> +struct ds1390 {
> +	struct rtc_device *rtc;
> +	u8 buf[9];	/* cmd + 8 registers */
> +	u8 tx_buf[2];
> +	u8 rx_buf[2];
> +};
> +

 don't we still have too many buffers?

 the use of bin2bcd an bcd2bin (lowercase) would also be appreciated.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

