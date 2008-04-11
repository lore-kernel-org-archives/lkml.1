Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYDKKrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYDKKrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbYDKKqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:46:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:51803 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758374AbYDKKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:46:53 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-164.messagelabs.com!1207910812!3233190!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 12:46:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GPIO: #include <linux/kernel.h> for might_sleep
Message-ID: <20080411104604.GA19973@digi.com>
References: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 10:46:05.0210 (UTC) FILETIME=[3E0D1FA0:01C89BC1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--15.073000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
> Hello David,
> 
> I like having headers being independend of the order of inclusion.
> Usually I order all includes alphabetically (and grouped by linux/,
> asm/, etc.).  This doesn't work with gpio.h because then kernel.h is
> included to late.
I just noticed that you need include/asm/types.h also for the
CONFIG_HAVE_GPIO_LIB=y case.  So the #include can better go to the top
of include/asm-generic/gpio.h.

I won't send a new version untill you say if it's OK for you to add
#includes to that header.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
