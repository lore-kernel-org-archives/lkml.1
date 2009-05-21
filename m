Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZEUJe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZEUJe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZEUJeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:34:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26808 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZEUJeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:34:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A151E9F.1080405@tremplin-utc.net>
Date: Thu, 21 May 2009 11:27:59 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 0/4] lis3: clean up and updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Here is a patch series for the lis3lv02d accelerometer driver. The main
goal was to  clean up the driver by removing non-necessary code.
However, during the process a few minor bugs were discovered and fixed.
Also the usual share of new axis conversion for known laptop models has
been added.

Andrew, would you mind queuing this for 2.6.31?

Eric

 drivers/hwmon/hp_accel.c  |   21 ++----
 drivers/hwmon/lis3lv02d.c |  169 +++++++++++++++------------------------------
 drivers/hwmon/lis3lv02d.h |   10 +--
 3 files changed, 67 insertions(+), 133 deletions(-)


