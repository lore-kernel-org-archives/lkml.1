Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYKNUza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYKNUza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 15:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKNUzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 15:55:16 -0500
Received: from mail1.radix.net ([207.192.128.31]:51697 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYKNUzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 15:55:15 -0500
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
	are __le16
From: Andy Walls <awalls@radix.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1226691865.5483.47.camel@brick>
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
	 <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
	 <1226690438.5483.39.camel@brick>
	 <412bdbff0811141125x34de747dm85b47f61b604219a@mail.gmail.com>
	 <1226691865.5483.47.camel@brick>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 15:55:57 -0500
Message-Id: <1226696157.3312.92.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 11:44 -0800, Harvey Harrison wrote:

> But I'd suggest
> that if you want to improve the maintainability of this code that someone
> in v4l-land start running sparse regularly 

For those who don't get the daily 'bot mail on the v4l-dvb-maintainer
list, Hans Verkuil's v4l-dvb build 'bot runs sparse builds daily for all
of v4l-dvb land:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-November/008595.html

Although developers won't see waring/error outputs from those runs until
after their changes are merged in the main v4l-dvb repo.

The latest kernel this automatic sparse build compiles is currently
2.26.28-rc4.  I've used it to monitor the cx18 driver for sparse build
errors so I could address them - it's quite convenient.

Regards,
Andy

