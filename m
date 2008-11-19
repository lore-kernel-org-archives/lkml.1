Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYKSXbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYKSXbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKSXbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:31:37 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:47073 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbYKSXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:36 -0500
Message-ID: <4924A1CF.1050703@euromail.se>
Date: Thu, 20 Nov 2008 00:31:27 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se> <20081119113508.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20081119113508.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L2wWF-0004DQ-3g.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1L2wWF-0004DQ-3g d0eb1dc7779b643f7d164e5b1f336110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Fri, Nov 07, 2008 at 12:15:29PM +0100, Henrik Rydberg wrote:
>> In order to utilize the full power of the new multi-touch devices, a
>> way to report detailed finger data to user space is needed. This patch
>> adds a multi-touch (MT) protocol which allows drivers to report details
>> for an arbitrary number of fingers.
>>
[...]
> 
> Sorry for the long silence. I don't think utilizing button events for
> this is a good idea. I'd rather just start reporting extended touch
> events for a finger and signal end of sub-packet with something like
> EV_SYN/SYN_MT_REPORT.
> 

Long time no see :-)

Yes, there has been quite a bit of feedback on this patch, and using
EV_SYN the way you suggest came up. Thanks - will redo.

Henrik

