Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0CKLEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:04:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52861 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757087Ab0CKLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:04:40 -0500
Date: Thu, 11 Mar 2010 11:04:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: axel lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, lrg@slimlogic.co.uk
Subject: Re: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
Message-ID: <20100311110438.GF2585@rakim.wolfsonmicro.main>
References: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
X-Cookie: Will it improve my CASH FLOW?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 09:56:34AM +0800, axel lin wrote:
> From 99175ed0f281d54efdaf8eef548077a8f0b4924a Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Thu, 11 Mar 2010 09:50:07 +0800
> Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
> 
> Given x=0,1,2, current implementation of BUCK_VOL_CHANGE_SHIFT(x) returns 0,4,8.
> The correct return value should be 0,4,6.
> This patch fix the logic.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

with the same comment about ideally wanting someone who worked on the
driver previously to check stuff.
