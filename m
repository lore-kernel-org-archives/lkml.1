Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0CAK4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:56:31 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:46418 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0CAK43 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:56:29 -0500
Date: Mon, 1 Mar 2010 11:56:25 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [rtc-linux] [PATCH 6/6] rtc/mc13783: implement alarm
Message-ID: <20100301115625.5d048580@linux.lan.towertech.it>
In-Reply-To: <1267440825-14694-6-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1267440825-14694-6-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Mar 2010 11:53:45 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> for now this just ignores the possible race to trigger an alarm when
> setting the time.  Should I resolve that, if so, what is the prefered
> way to do that?

 I saw you email on the topic but I haven't had
 the time to answer appropriately. 

 I'd suggest to disable the alarm irq while setting
 the time.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

