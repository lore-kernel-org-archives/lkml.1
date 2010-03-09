Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0CIQti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:49:38 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:29675 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0CIQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:49:33 -0500
Date: Tue, 9 Mar 2010 08:42:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Richard =?UTF-8?B?UsO2amZvcnM=?= <richard.rojfors@pelagicore.com>,
       Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_I2C_XILINX doesn't complie
Message-Id: <20100309084229.6aa00ce8.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LNX.2.00.1003091727461.17799@pobox.suse.cz>
References: <alpine.LNX.2.00.1003091727461.17799@pobox.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B967AD4.0043:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010 17:31:04 +0100 (CET) Jiri Kosina wrote:

> Hi,
> 
> current Linus' tree (57d54889cd00) doesn't compile when CONFIG_I2C_XILINX 
> is enabled:
> 
> drivers/i2c/busses/i2c-xiic.c:39:28: error: linux/i2c-xiic.h: No such file or directory
> drivers/i2c/busses/i2c-xiic.c: In function ‘xiic_i2c_probe’:
> drivers/i2c/busses/i2c-xiic.c:750: error: dereferencing pointer to incomplete type
> drivers/i2c/busses/i2c-xiic.c:751: error: dereferencing pointer to incomplete type
> 
> Seems like the following commit
> 
> 	commit e1d5b6598cdc33257fe68302ae9db81d2f7bb883
> 	Author: Richard Röjfors <richard.rojfors@pelagicore.com>
> 	Date:   Thu Feb 11 10:42:00 2010 +0100
> 
> 	    i2c: Add support for Xilinx XPS IIC Bus Interface
> 
> forgot to add some header files.


http://lkml.org/lkml/2010/3/9/50http://lkml.org/lkml/2010/3/9/50

---
~Randy
