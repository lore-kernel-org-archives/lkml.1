Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbYEIAXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbYEIAXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYEIAXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:23:41 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64833 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753136AbYEIAXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:23:40 -0400
Date: Fri, 9 May 2008 01:17:21 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
cc: a.zummo@towertech.it, khali@linux-fr.org, ralf@linux-mips.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, ab@mycable.de,
       mgreer@mvista.com
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80, etc. driver
In-Reply-To: <20080508.133847.74565891.nemoto@toshiba-tops.co.jp>
Message-ID: <Pine.LNX.4.55.0805090054300.5944@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070102460.16173@cliff.in.clinika.pl>
 <20080508.133847.74565891.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Atsushi Nemoto wrote:

> For write transfer, you must use only one i2c_msg.  If two i2c_msg
> were used, the slave address is inserted between register number and
> first data.  This chip cannot accept such sequence.

 Correct, thank you for pointing it out -- verified with the datasheet.  I 
will send an updated patch separately taking other suggestions into 
account as well.

> On success, m41t80_i2c_transfer() returns positive value, but
> m41t80_transfer() should return 0.

 I think the check should be for values below zero as originally instead.  
Thanks for the point again.

  Maciej
