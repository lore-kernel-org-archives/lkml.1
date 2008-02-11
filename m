Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbYBKNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbYBKNHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYBKNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:07:04 -0500
Received: from smtp.movial.fi ([62.236.91.34]:58526 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYBKNHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:07:03 -0500
Date: Mon, 11 Feb 2008 15:07:00 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Riku Voipio <riku.voipio@movial.fi>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: futex local DoS on most architectures
Message-ID: <20080211130700.GF27537@movial.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue described in [1] is still present and unfixed (and even the 
fix there wasn't complete since it didn't cover SMP).

Thanks to Riku Voipio for noting that it is still unfixed.

cu
Adrian

[1] http://lkml.org/lkml/2007/8/1/474
