Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZBGWf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZBGWf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZBGWfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:35:52 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:10700 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZBGWfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:35:52 -0500
X-Spam-Flag: NO
X-Spam-Score: -10.543
Message-ID: <498D9F02.9000107@tremplin-utc.net>
Date: Sat, 07 Feb 2009 15:47:30 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
In-Reply-To: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:
> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
> axis.
> 
> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>

Looks good.
Andrew, would you mind queuing it?
> ---
> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
> patch marks the inversion for all the dv5. I can include the full
> dmidecode output if this is deemed necessary.
> 
> With the laptop standing still on my desk jstest reports X and Y values
> fluctuating from -8k to +8k (more or less). I assume this is normal?
What does "k" stands for? If that's the unit of the joystick output:
yes, that's perfectly normal, just some noise/vibration. If that's 1000,
it's far too much to be normal.

Eric

