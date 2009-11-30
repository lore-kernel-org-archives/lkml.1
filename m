Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZK3PQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZK3PQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZK3PQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:16:14 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31837 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZK3PQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:16:13 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B13E1C2.9050403@tremplin-utc.net>
Date: Mon, 30 Nov 2009 16:16:18 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3 4/5] lis3: Scale output values to mg
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-5-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1258622842-23129-5-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 10:27, Samu Onkalo schreef:
> Report output values as 1/1000 of earth gravity.

:
Looks good, excepted that you have some constants with a very long name.

:
> +#define LIS3_SCALING_ACCURACY           1024
> +#define LIS3_2G2G_SENSITIVITY_WAI_12B	((LIS3_SCALING_ACCURACY * 1000) / 1024)
> +#define LIS3_2G2G_SENSITIVITY_WAI_8B	(18 * LIS3_SCALING_ACCURACY)
As you'll have to rebase it anyway for the path 3, could you change
those constants to have a shorter name? At least "WAI" could go away.
And what does 2G2G stands for?

Eric
