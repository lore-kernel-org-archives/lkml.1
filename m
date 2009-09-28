Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZI1NWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZI1NWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZI1NWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:22:09 -0400
Received: from bamako.nerim.net ([62.4.17.28]:65519 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZI1NWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:22:09 -0400
Date: Mon, 28 Sep 2009 15:22:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
Message-ID: <20090928152210.593e5d48@hyperion.delvare>
In-Reply-To: <20090928131700.GA19243@nb-core2.darkstar.lan>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	<51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	<20090928131700.GA19243@nb-core2.darkstar.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

On Mon, 28 Sep 2009 15:17:00 +0200, Luca Tettamanti wrote:
> I have a new patch for you :)
> It contains the previous changes to handle the bigger ASBF buffer plus a new
> method to enable the EC as suggested by Asus. Be sure to compile with
> HWMON_DEBUG_CHIP enabled.

Wow, that's a lot of code to just enable the EC, I hoped it would be
more simple than this :(

Wouldn't it make sense to also disable the EC when the asus_atk0110
driver is removed? To restore the chip to its initial state.

-- 
Jean Delvare
