Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbYBSKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbYBSKAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYBSKAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:00:10 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2556 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754318AbYBSKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:00:08 -0500
Date: Tue, 19 Feb 2008 10:52:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] adt7473: New driver for Analog Devices  ADT7473 sensor
 chip
Message-ID: <20080219105210.2b8b0960@hyperion.delvare>
In-Reply-To: <20080218213234.GC5784@tree.beaverton.ibm.com>
References: <20071219034116.GM6870@tree.beaverton.ibm.com>
	<20071219154759.7be5025c@hyperion.delvare>
	<20071219231437.GR6870@tree.beaverton.ibm.com>
	<20080217200250.GD2916@jupiter.solarsys.private>
	<20080218213234.GC5784@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 13:32:34 -0800, Darrick J. Wong wrote:
> Ok.  I wonder if the nouveau people have any intention to
> reverse-engineer the i2c controller?

There's probably not much to reverse-engineer, the nvidiafb driver has
been supporting the I2C controllers (using software-driven bit-banging)
for a long time now. Maybe the hardware can do better but it's probably
not a big deal as I2C access on a graphics adapter isn't performance
critical.

-- 
Jean Delvare
