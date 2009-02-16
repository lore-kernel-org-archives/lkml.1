Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZBPNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZBPNeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZBPNeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:34:00 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:6704 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZBPNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:33:59 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49996B42.5040500@tremplin-utc.net>
Date: Mon, 16 Feb 2009 14:33:54 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Mike Chan <mike@android.com>
Cc: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Governor poll frequency tuneables exported in
 config.
References: <1234469284-15924-1-git-send-email-mike@android.com>
In-Reply-To: <1234469284-15924-1-git-send-email-mike@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan schreef:
>     cpufreq: Governor poll frequency tuneables exported in config.
>     
Hello,

> +config CPU_FREQ_MIN_TICKS
> +	int "Ticks between governor polling interval."
> +	default 10
> +	help
> +	  Minimum number of ticks between polling interval for governors.
I don't think it makes much sense to let anyone tune this parameter.
This is a constant that says we need at least a 10% granularity to
compute any statistic correctly. There is nothing much to be discussed
or tuned.


> +config CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER
> +	int "Sampling rate multiplier for governors."
> +	default 1000
> +	help
> +	  Sampling latency rate multiplied by the cpu switch latency.
> +	  Affects governor polling.
This one, why not (although I don't think it's worth neither), and it
would need a better documentation.

Eric

