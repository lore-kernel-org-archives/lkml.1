Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYJTLyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYJTLyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYJTLxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:53:43 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:38781 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752112AbYJTLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:53:42 -0400
Message-ID: <48FC6F18.6040809@mimc.co.uk>
Date: Mon, 20 Oct 2008 12:44:24 +0100
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
CC: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] Add Dallas DS1390 RTC chip
References: <48FC442E.9070206@mimc.co.uk> <20081020114607.1b0299cb@i1501.lan.towertech.it>
In-Reply-To: <20081020114607.1b0299cb@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Mon, 20 Oct 2008 09:41:18 +0100
> Mark Jackson <mpfj@mimc.co.uk> wrote:
> 
>> +struct ds1390 {
>> +	struct rtc_device *rtc;
>> +	u8 buf[9];	/* cmd + 8 registers */
>> +	u8 tx_buf[2];
>> +	u8 rx_buf[2];
>> +};
>> +
> 
>  don't we still have too many buffers?

Ah yes ... ooops !!

> 
>  the use of bin2bcd an bcd2bin (lowercase) would also be appreciated.
> 

Will do.

Mark
