Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0CIQbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:31:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0CIQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:31:06 -0500
Date: Tue, 9 Mar 2010 17:31:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: CONFIG_I2C_XILINX doesn't complie
Message-ID: <alpine.LNX.2.00.1003091727461.17799@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

current Linus' tree (57d54889cd00) doesn't compile when CONFIG_I2C_XILINX 
is enabled:

drivers/i2c/busses/i2c-xiic.c:39:28: error: linux/i2c-xiic.h: No such file or directory
drivers/i2c/busses/i2c-xiic.c: In function ‘xiic_i2c_probe’:
drivers/i2c/busses/i2c-xiic.c:750: error: dereferencing pointer to incomplete type
drivers/i2c/busses/i2c-xiic.c:751: error: dereferencing pointer to incomplete type

Seems like the following commit

	commit e1d5b6598cdc33257fe68302ae9db81d2f7bb883
	Author: Richard Röjfors <richard.rojfors@pelagicore.com>
	Date:   Thu Feb 11 10:42:00 2010 +0100

	    i2c: Add support for Xilinx XPS IIC Bus Interface

forgot to add some header files.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
