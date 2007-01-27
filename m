Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbXA0HjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbXA0HjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 02:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXA0HjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 02:39:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44103 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXA0HjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 02:39:22 -0500
Date: Fri, 26 Jan 2007 23:39:11 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Kristian =?ISO-8859-1?B?SPhnc2Jlcmci?= <krh@bitplanet.net>"@osdl.org
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: In-tree version of new FireWire drivers available
Message-Id: <20070126233911.7ebf96ac.akpm@osdl.org>
In-Reply-To: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 22:48:15 -0500
"Kristian Høgsberg" <krh@bitplanet.net> wrote:

> I've moved the new FireWire stack to an in-tree git repository and
> moved over the missing patches from my out-of-tree version.

arm:

drivers/firewire/fw-device.c: In function `fw_device_init':
drivers/firewire/fw-device.c:495: warning: implicit declaration of function `cmpxchg'                                                                           

We can't use cmpxchg in generic code.
