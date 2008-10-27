Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYJ0QwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYJ0QwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJ0QwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:52:12 -0400
Received: from mx0.towertech.it ([213.215.222.73]:57599 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751092AbYJ0QwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:52:11 -0400
Date: Mon, 27 Oct 2008 17:51:59 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: broonie@opensource.wolfsonmicro.com, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re:  [PATCH 1/2] rtc: Fix handling of missing tm_year data when
 reading alarms
Message-ID: <20081027175159.14d51466@i1501.lan.towertech.it>
In-Reply-To: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 15:38:24 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> When fixing up invalid years rtc_read_alarm() is callign rtc_valid_tm()
> as a boolean but rtc_valid_tm() returns zero on success or a negative
> number if the time is not valid so the test is inverted.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

