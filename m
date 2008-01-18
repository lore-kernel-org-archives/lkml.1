Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYARSqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYARSqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764911AbYARSqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:46:19 -0500
Received: from mail0.scram.de ([78.47.204.202]:42071 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764834AbYARSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:46:18 -0500
X-Spam-Score: -4.054
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <4790F44F.8020009@scram.de>
Date: Fri, 18 Jan 2008 19:47:43 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
References: <478F4AE3.5090803@scram.de> <20080118183905.2d5d8474@lxorguk.ukuu.org.uk>
In-Reply-To: <20080118183905.2d5d8474@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>> If a freescale watchdog device node is present, reset the watchdog
>> while waiting for serial input.
> 
> Why ? We normally rely on user space for watchdog management as only the
> fact user space is behaving really proves a box is happy ?

This is in the boot wrapper code, not in the linux kernel.

Thanks,
Jochen
