Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0BDV5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:57:11 -0500
Received: from n22b.bullet.mail.mud.yahoo.com ([68.142.206.159]:26529 "HELO
	n22b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752139Ab0BDV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:57:09 -0500
X-Yahoo-Newman-Id: 934756.57349.bm@omp424.mail.mud.yahoo.com
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: CtjoSvAVM1kl4H7g_yKiSrVcWuhLxs2gg5BaTi3oMWCcpKzhptzyeKqHHzBsOb9HGXZYsDW_78oeURCJaKHBM4.7MMYM8vHq8RgyY.8UafHPdSyDy_xGn3L1a_7U4pFUHjh3cs818eZ2lDABu5tBkfI.tV.an5aALlrL6NQL5X84DT9OtD1i9YYjgiEe4Fji0Yr.r2FmoAUYU81lNFsafA56pNMZbyY6NhO2GhMDUZDj.cFTa_FLlbO2.dLIjEFDsuQ521_OCqFFlAfX1wwn2uinMEZO79t20U6O.pzqzhMu7LAYNhjDcoW0Wm6z1DPT6ddMpEJLJJ3kiFYdd6_tvqBs9PmJsgqUECafBzb8DdJcouheMbmBXoeLNu6x332De9VsLQor
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: driver for TI tmp102 temperature sensor
Date: Thu, 4 Feb 2010 13:57:06 -0800
User-Agent: KMail/1.9.9
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
References: <201002031723.49976.sfking@fdwdc.com> <20100204193712.22e8b6e7@hyperion.delvare>
In-Reply-To: <20100204193712.22e8b6e7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002041357.06748.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 10:37:12 Jean Delvare wrote:
> Hi Steven,
>
> On Wed, 3 Feb 2010 17:23:49 -0800, Steven King wrote:
> > The TI TMP102 is similar to the lm75.  It differs from the lm75 by having
> > a 16 bit conf register and the temp registers have a minimum resolution
> > of 12bits; the extended conf register can select 13 bit resolution (which
> > this driver does) and also change the update rate (which this driver
> > currently doesn't use).
> >
> > Signed-off-by: Steven King <sfking@fdwdc.com>
> > ---
> >
> > Driver for the TI TMP102.
>
> Could you please send a dump of your TMP102 chip, using i2cdump in word
> mode?

sure, like so?

# ./i2cdump 0 0x4a w
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-0, address 0x4a, mode word
Continue? [Y/n] y
     0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
00: d90c b062 002d 004b c01a d006 0000 0000
08: d90c b062 002d 004b c01a d006 0000 0000
10: d90c b062 002d 004b c01a d006 0000 0000
18: d90c b062 002d 004b c01a d006 0000 0000
20: d90c b062 002d 004b c01a d006 0000 0000
28: d90c b062 002d 004b c01a d006 0000 0000
30: d90c b062 002d 004b c01a d006 0000 0000
38: d90c b062 002d 004b c01a d006 0000 0000
40: d90c b062 002d 004b c01a d006 0000 0000
48: d90c b062 002d 004b c01a d006 0000 0000
50: d90c b062 002d 004b c01a d006 0000 0000
58: d90c b062 002d 004b c01a d006 0000 0000
60: d90c b062 002d 004b c01a d006 0000 0000
68: d90c b062 002d 004b c01a d006 0000 0000
70: d90c b062 002d 004b c01a d006 0000 0000
78: d90c b062 002d 004b c01a d006 0000 0000
80: d90c b062 002d 004b c01a d006 0000 0000
88: d90c b062 002d 004b c01a d006 0000 0000
90: d90c b062 002d 004b c01a d006 0000 0000
98: d90c b062 002d 004b c01a d006 0000 0000
a0: d90c b062 002d 004b c01a d006 0000 0000
a8: d90c b062 002d 004b c01a d006 0000 0000
b0: d90c b062 002d 004b c01a d006 0000 0000
b8: d90c b062 002d 004b c01a d006 0000 0000
c0: d90c b062 002d 004b c01a d006 0000 0000
c8: d90c b062 002d 004b c01a d006 0000 0000
d0: d90c b062 002d 004b c01a d006 0000 0000
d8: d90c b062 002d 004b c01a d006 0000 0000
e0: d10c b062 002d 004b c01a d006 0000 0000
e8: d10c b062 002d 004b c01a d006 0000 0000
f0: d10c b062 002d 004b c01a d006 0000 0000
f8: d10c b062 002d 004b c01a d006 0000 0000
# 

-- 
Steven King -- sfking at fdwdc dot com

