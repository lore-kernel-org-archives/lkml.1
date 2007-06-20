Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXFTENU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXFTENU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXFTENO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:13:14 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:55141 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXFTENN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:13:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq1HAGZGeEZKhRO4R2dsb2JhbACHHoduAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Qi Yong <qiyong@mail.fc-cn.com>
Subject: Re: [patch] add printk_ratelimit to atkbd_interrupt
Date: Wed, 20 Jun 2007 00:13:12 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070620011753.GA16692@virgo.fc-cn.com>
In-Reply-To: <20070620011753.GA16692@virgo.fc-cn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706200013.13029.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 21:17, Qi Yong wrote:
> Add printk_ratelimit() to atkbd_interrupt(). I get "Spurious ACK" messages flushing on my
> screen. This patch helps to read the screen.
> 

Will apply, thank you.

Do you have any idea why you are getting spurios ACK messages? Do you have
an application fiddling with keyboard port or do you have blink driver
enabled?

-- 
Dmitry
