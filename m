Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZEZPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZEZPSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZEZPR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:17:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48243 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZEZPR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:17:56 -0400
Message-ID: <4A1C0818.3010003@redhat.com>
Date: Tue, 26 May 2009 11:17:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: ext-eero.nurkkala@nokia.com
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] NOHZ: Properly feed cpufreq ondemand governor
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
In-Reply-To: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext-eero.nurkkala@nokia.com wrote:
> From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> 
> A call from irq_exit() may occasionally pause the timing
> info for cpufreq ondemand governor. This results in the
> cpufreq ondemand governor to fail to calculate the 
> system load properly. Thus, relocate the checks for this
> particular case to keep the governor always functional.
> 
> Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> Reported-by: Tero Kristo <tero.kristo@nokia.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
