Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYEIOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYEIOQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYEIOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:16:15 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:50516 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYEIOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:16:14 -0400
Date: Fri, 09 May 2008 23:17:19 +0900 (JST)
Message-Id: <20080509.231719.93019066.anemo@mba.ocn.ne.jp>
To: macro@linux-mips.org
Cc: david-b@pacbell.net, ab@mycable.de, mgreer@mvista.com, i2c@lm-sensors.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
	<200805071625.20430.david-b@pacbell.net>
	<Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 01:43:32 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>  Here is a new version of the patch.  I hope I have addressed all your
> concerns, but I am officially dead at the moment, so please do not disturb
> me until this is no longer the case.

This version works fine for me (with i2c-gpio).  And as Jean said,
using i2c_smbus_(write|read)_i2c_block_data instead of
m41t80_i2c_(write|read) works fine too.

---
Atsushi Nemoto
