Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZLIUud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZLIUud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZLIUub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:50:31 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:35370 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZLIUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:50:30 -0500
Date: Wed, 9 Dec 2009 12:49:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: mmotm 2009-12-08-17-45 uploaded (max7301)
Message-Id: <20091209124956.b5842cc2.randy.dunlap@oracle.com>
In-Reply-To: <200912090209.nB929xbS027852@imap1.linux-foundation.org>
References: <200912090209.nB929xbS027852@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B200D87.0035:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Dec 2009 17:45:48 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-12-08-17-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.32:


Same problem as reported for mmotm of 2009-11-24:

see http://marc.info/?l=linux-kernel&m=125920001302188&w=2

max7301.c:(.text+0x224c): undefined reference to `i2c_smbus_write_byte_data'
max7301.c:(.text+0x2259): undefined reference to `i2c_smbus_read_byte_data'
max7301.c:(.init.text+0x19b): undefined reference to `i2c_register_driver'
max7301.c:(.init.text+0x1ca): undefined reference to `i2c_del_driver'
max7301.c:(.exit.text+0xc): undefined reference to `i2c_del_driver'

I2C=m, MAX7301=y

---
~Randy
