Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbZDBWHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbZDBWHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbZDBWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:07:40 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:55845 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZDBWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:07:39 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49D536FA.2050307@lwfinger.net>
Date: Thu, 02 Apr 2009 17:06:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: rpurdie@rpsys.net
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] leds: Increase trigger name maximum size
References: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
In-Reply-To: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> On my HP dv2815 laptop, the total length of the triggers for my b43legacy
> wireless device exceeds the maximum value of 50 defined in
> include/linux/leds.h. As a result, the list is garbled.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

Richard,

Please drop this. That length change is a red herring. Something is corrupting
the list of triggers, but this length is not it.

Sorry for the noise.

Larry

