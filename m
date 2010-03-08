Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0CHHmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:42:04 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHHmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:42:00 -0500
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Zaliva <lord@crocodile.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 08:41:57 +0100
Message-ID: <1268034117.3819.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 11:47 -0800, Vadim Zaliva wrote:
> This small patch is fixing an integer overflow issue in 'appletouch' driver.
> 
> In particular, reading data from Geyser 2 touchpads used on post Oct
> 2005 Apple PowerBooks the driver was casting X and Y coordinates
> values to 'signed char'. Testing on one of such PowerBooks I have
> noticed that touchpad always generates positive values, but some of
> them are greater that 127, and thus, when cast to 'signed char' being
> interpreted as a negative.
> 
> Such bigger values have been observed infrequently, closer to the
> edges of a touchpad, so the problem was not very visible. 
> Nevertheless, the patch would potentially improve touchpad
> driver accuracy.

Hmm, you're probably right, and I cannot test with my powerbook as I'm
about to leave on travel and it's at my parents.

johannes

