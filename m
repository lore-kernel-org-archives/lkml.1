Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXFMLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXFMLRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbXFMLQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:16:57 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58764 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757861AbXFMLQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:16:56 -0400
Date: Wed, 13 Jun 2007 13:15:02 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH] i2c-gpio: Add support for new-style clients
Message-ID: <20070613131502.6329b80c@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
References: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007 00:43:16 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Use i2c_bit_add_numbered_bus() if device id specified, so that the
> i2c-gpio adapter works well with new-style pre-declared devices.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Makes sense to me. I haven't got any test setup with multiple i2c
busses, but using the platform_device id seems like the obvious way to
number the busses from a board developer's point of view.

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
