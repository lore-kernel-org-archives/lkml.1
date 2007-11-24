Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXKXW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXKXW0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXKXW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:26:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:46670 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXKXW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:26:08 -0500
Subject: Re: radeonfb i2c regression post-2.6.18.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Michael Buesch <mb@bu3sch.de>, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
In-Reply-To: <20071124232035.0f46d530@hyperion.delvare>
References: <1195427766.7022.18.camel@pasglop>
	 <200711231700.53103.mb@bu3sch.de>
	 <20071123232928.467378a7@hyperion.delvare>
	 <200711241518.26755.mb@bu3sch.de>
	 <20071124232035.0f46d530@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 25 Nov 2007 09:25:35 +1100
Message-Id: <1195943135.7195.61.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Very strange indeed. Another possibility is that there is a hardware
> monitoring chip connected to one of the Radeon adapter's I2C buses, and
> that holding the I2C lines prevents reading from it, so whatever is
> responsible for controlling the temperature prefers to play it safe and
> shuts everything down. Somehow it seems more realistic than an actual
> overheating (3 seconds is a very short period of time for that), but
> we'd need the exact schematics of the hardware, and the details of the
> thermal control system, to validate this theory.
> 
> Anyway, no need to worry anymore now that the bug is fixed :)

Actually, that's a possibility yes, though generally Apple put all temp.
monitoring chips elsewhere, it could well be the case.

Ben.


