Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbZJLQsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbZJLQsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932460AbZJLQsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:48:31 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:35900 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369AbZJLQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:48:30 -0400
Date: Mon, 12 Oct 2009 18:47:39 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Andrew Sharp <andy.sharp@lsi.com>,
       Thomas Hommel <thomas.hommel@gefanuc.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] rtc-ds1511: Fix races around device registration
Message-ID: <20091012184739.46bb1052@i1501.lan.towertech.it>
In-Reply-To: <1255365461-5732-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1255365461-5732-1-git-send-email-anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 01:37:40 +0900
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> * Call dev_set_drvdata before rtc device creation
> * Use its own spinlock instead of rtc->irq_lock

 why?

> * Check pdata->rtc before calling rtc_update_irq
> * Use {alarm,update}_irq_enable and remove ioctl routine
> * Use devres APIs and simplify error/remove path

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

