Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXEOGfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXEOGfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbXEOGfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:35:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759430AbXEOGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:35:23 -0400
Date: Mon, 14 May 2007 23:34:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-Id: <20070514233401.cfeed9b0.akpm@linux-foundation.org>
In-Reply-To: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
References: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 01:43:42 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Here is the 3rd iteration with the following changes:
> - Modified to be an i2c "new style" driver based on David Brownell's work
> - uses the new prototype for i2c_smbus_read_i2c_block_data() for block data
>   reads instead of a single byte at a time.\

What new prototype for i2c_smbus_read_i2c_block_data()?

drivers/i2c/chips/ds1682.c: In function 'ds1682_show':
drivers/i2c/chips/ds1682.c:75: warning: passing argument 3 of 'i2c_smbus_read_i2c_block_data' makes pointer from integer without a cast
drivers/i2c/chips/ds1682.c:75: error: too many arguments to function 'i2c_smbus_read_i2c_block_data'
drivers/i2c/chips/ds1682.c: In function 'ds1682_eeprom_read':                                                                                                                             drivers/i2c/chips/ds1682.c:165: warning: passing argument 3 of 'i2c_smbus_read_i2c_block_data' makes pointer from integer without a cast
drivers/i2c/chips/ds1682.c:165: error: too many arguments to function 'i2c_smbus_read_i2c_block_data'
