Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXEONNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXEONNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 09:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXEONNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 09:13:46 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:3166 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754559AbXEONNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 09:13:46 -0400
Date: Tue, 15 May 2007 15:14:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-ID: <20070515151437.3385449b@hyperion.delvare>
In-Reply-To: <20070514233401.cfeed9b0.akpm@linux-foundation.org>
References: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
	<20070514233401.cfeed9b0.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, 14 May 2007 23:34:01 -0700, Andrew Morton wrote:
> On Sun, 13 May 2007 01:43:42 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > 
> > Here is the 3rd iteration with the following changes:
> > - Modified to be an i2c "new style" driver based on David Brownell's work
> > - uses the new prototype for i2c_smbus_read_i2c_block_data() for block data
> >   reads instead of a single byte at a time.\
> 
> What new prototype for i2c_smbus_read_i2c_block_data()?
> 
> drivers/i2c/chips/ds1682.c: In function 'ds1682_show':
> drivers/i2c/chips/ds1682.c:75: warning: passing argument 3 of 'i2c_smbus_read_i2c_block_data' makes pointer from integer without a cast
> drivers/i2c/chips/ds1682.c:75: error: too many arguments to function 'i2c_smbus_read_i2c_block_data'
> drivers/i2c/chips/ds1682.c: In function 'ds1682_eeprom_read':
> drivers/i2c/chips/ds1682.c:165: warning: passing argument 3 of 'i2c_smbus_read_i2c_block_data' makes pointer from integer without a cast
> drivers/i2c/chips/ds1682.c:165: error: too many arguments to function 'i2c_smbus_read_i2c_block_data'

Please drop your version of the DS1682 patch, and refresh my
jdelvare-i2c quilt tree. You'll get the i2c_smbus_read_i2c_block_data
prototype update as well as the final version of Grant's DS1682 patch.

You would save yourself quite some work if you were waiting for i2c
patches to come to you through my tree. I am paying attention to the
dependencies, exactly in order to prevent problems like the one above.
Not to say I am not grateful when you collect important i2c fixes which
have been sent only to LKML and that I would otherwise have missed, but
in the case of the DS1682 patch, it was pretty visible that I was taking
care of it.

Thanks,
-- 
Jean Delvare
