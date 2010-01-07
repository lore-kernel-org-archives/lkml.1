Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996Ab0AGGlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0AGGlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828Ab0AGGlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:41:51 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:58059 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0AGGlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:41:51 -0500
Message-ID: <4B458209.2030600@xenontk.org>
Date: Thu, 07 Jan 2010 12:11:13 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: James Simmons <jsimmons@infradead.org>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com> <1262797226-9593-2-git-send-email-jhovold@gmail.com> <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org> <20100106180950.GD10442@localhost> <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org> <20100106191234.GE10442@localhost>
In-Reply-To: <20100106191234.GE10442@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 12:42 AM, Johan Hovold wrote:
>> Yeap. The fix uncovered a bug in your driver. I haven't heard of problems 
>> with the other drm drivers.
>>  
>>> The backlight is handled via the DRI driver I assume. At least
>>> i9xx_crtc_dpms is called on powerdown.
>>
>> Can you post your dmesg and kernel config.

[snip]

Adding the Intel DRM people in CC as well. I have the same issue with my
GM45.
