Return-Path: <linux-kernel-owner+w=401wt.eu-S1762525AbXH3QlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762525AbXH3QlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbXH3Qk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:40:58 -0400
Received: from avexch2.qlogic.com ([198.70.193.116]:15440 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbXH3Qk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:40:58 -0400
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 12:40:57 EDT
Message-ID: <46D6EFE7.40802@qlogic.com>
Date: Thu, 30 Aug 2007 09:27:19 -0700
From: Seokmann Ju <seokmann.ju@qlogic.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Abhishek Kane <abhishek.kane@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-driver@qlogic.com,
       linux-scsi@vger.kernel.org
Subject: Re: FC - NPIV in 2.6.23-rc2
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
In-Reply-To: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2007 16:24:55.0506 (UTC) FILETIME=[4CE85B20:01C7EB22]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Kane wrote:
> Hi,
> 
> With the NPIV support been merged into 2.6.23-rc2, i was interested in
> trying it out on my setup. But i understand from the code that this support
> (NPIV) is only for 24xx cards.
> I need to undertand what are the problems in making it available for 23xx
> cards.
It is not supported. There is no technical issues, though, it won't be supported.

> Also, when going through various docs i came across these 2 terms related to
> port virtualization, viz. NPIV & Multiport id. But i couldn't understand the
> inherent difference in these 2 technologies. So if you guys are aware of
> some sought of documentation for this, please let me know.
NPIV is a feature to provide multiple path available on one physical port and it has implemented based on the multiport ID (MID) capability on the switch.
So, you have to have the switch with MID capable on the configuration to support NPIV, besides the controller.

Thank you,
Seokmann
