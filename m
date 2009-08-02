Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZHBAWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZHBAWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 20:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZHBAWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 20:22:05 -0400
Received: from c60.cesmail.net ([216.154.195.49]:53814 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZHBAWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 20:22:04 -0400
Subject: Re: rt2800usb: memory corruption?
From: Pavel Roskin <proski@gnu.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1249124154.8236.5.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
	 <1249104348.7146.60.camel@marge.simson.net>
	 <1249124154.8236.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 20:21:54 -0400
Message-Id: <1249172514.3043.7.camel@ct>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 12:55 +0200, Mike Galbraith wrote:

> Enabled slub/pagealloc debugging.  First down/rmmod said...

I suggest that you try kmemcheck.  It's very slow, but it finds memory
problems when they occur, not when it's too late.

You may want to disable kmemleak and framebuffer support and make sure
that X doesn't start, at it will be too slow.  Slub debugging might
conflict with kmemcheck, so it's better to disable it.

-- 
Regards,
Pavel Roskin
