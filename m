Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbZLIVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbZLIVBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbZLIVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:01:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769AbZLIVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:01:29 -0500
Date: Wed, 9 Dec 2009 13:00:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: mmotm 2009-12-08-17-45 uploaded (max7301)
Message-Id: <20091209130046.648b6f58.akpm@linux-foundation.org>
In-Reply-To: <20091209124956.b5842cc2.randy.dunlap@oracle.com>
References: <200912090209.nB929xbS027852@imap1.linux-foundation.org>
	<20091209124956.b5842cc2.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 12:49:56 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 08 Dec 2009 17:45:48 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-12-08-17-45 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.32:
> 
> 
> Same problem as reported for mmotm of 2009-11-24:
> 
> see http://marc.info/?l=linux-kernel&m=125920001302188&w=2
> 
> max7301.c:(.text+0x224c): undefined reference to `i2c_smbus_write_byte_data'
> max7301.c:(.text+0x2259): undefined reference to `i2c_smbus_read_byte_data'
> max7301.c:(.init.text+0x19b): undefined reference to `i2c_register_driver'
> max7301.c:(.init.text+0x1ca): undefined reference to `i2c_del_driver'
> max7301.c:(.exit.text+0xc): undefined reference to `i2c_del_driver'
> 
> I2C=m, MAX7301=y

yup, thanks.

I made a note of this last time, via my highly formal process of adding
rude comments to the series file
(http://userweb.kernel.org/~akpm/mmotm/series):

#gpio-add-driver-for-max7300-i2c-gpio-extender.patch: kconfig borked (randy)

I use notes like that to prevent myself from merging the patch.

I often forget to remove the note when the patch gets fixed.
