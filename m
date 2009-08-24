Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZHXXjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZHXXjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZHXXjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:39:17 -0400
Received: from senator.holtmann.net ([87.106.208.187]:32990 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZHXXjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:39:16 -0400
Subject: Re: Fw: Build failure on linux-next master branch
From: Marcel Holtmann <marcel@holtmann.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-bluetooth@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
In-Reply-To: <20090825093707.13bf8c49.sfr@canb.auug.org.au>
References: <20090825093707.13bf8c49.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 16:38:35 -0700
Message-Id: <1251157115.2950.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> [Let try a few folks who might know]
> 
> Begin forwarded message:
> 
> Date: Mon, 24 Aug 2009 12:00:24 -0400 (EDT)
> From: Steven Rostedt <rostedt@goodmis.org>
> To: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
> Subject: Build failure on linux-next master branch
> 
> 
> 
> With latest next master branch I got this failure in my build system.
> 
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#1801)
>   MODPOST 96 modules
> ERROR: "crc16" [net/bluetooth/l2cap.ko] undefined!
> make[1]: *** [__modpost] Error 1

just pushed a fix from Randy to bluetooth-next-2.6 tree. The
CONFIG_L2CAP was missing a select CRC16.

Regards

Marcel


