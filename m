Return-Path: <linux-kernel-owner+w=401wt.eu-S1761872AbXEOHZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761872AbXEOHZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXEOHZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:25:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:62838 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXEOHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TjJLS5E4iKTsuGhujzYol+8bQqsgq+jCoBLP9fjeKxrIvHHytLfDjh2qUjQbjF14TGRGQzrtCEgU1tIRfHv/ecfY/UByRNM6kOZxfFoM0qUqsWkEmW1xkLN3PhFvXsBiHSUSz5NqVL4yd0txAupkEROJcn1PA6w+Fd9IjxZFmy4=
Message-ID: <528646bc0705150025w199cd3u926a80d9fedc67a5@mail.gmail.com>
Date: Tue, 15 May 2007 01:25:34 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Cc: "Jean Delvare" <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
In-Reply-To: <20070514233401.cfeed9b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
	 <20070514233401.cfeed9b0.akpm@linux-foundation.org>
X-Google-Sender-Auth: 0a4f5bb1b965e30a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
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
> drivers/i2c/chips/ds1682.c: In function 'ds1682_eeprom_read':                                                                                                                             drivers/i2c/chips/ds1682.c:165: warning: passing argument 3 of 'i2c_smbus_read_i2c_block_data' makes pointer from integer without a cast
> drivers/i2c/chips/ds1682.c:165: error: too many arguments to function 'i2c_smbus_read_i2c_block_data'

Sorry.  I forgot to drop linux-kernel when sending this patch.  It
depends on another patch that hasn't been merged yet.

Cheers,
g.

-- 
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
