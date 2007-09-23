Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXIWIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXIWIp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXIWIpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 04:45:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47822 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbXIWIpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 04:45:19 -0400
Date: Sun, 23 Sep 2007 10:45:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [RFC] New kernel-message logging API
In-Reply-To: <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> 
 <1190506383.30132.11.camel@localhost> <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23 2007 10:39, Vegard Nossum wrote:
>On 9/23/07, Joe Perches <joe@perches.com> wrote:
>> On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
>> > #define kprint(fmt, ...)
>>
>> Good ideas.  Perhaps a prefix of klog or kp_ instead?
>> Given the number of 80 column zealots, character naming length matters.
>
>I don't know. Compare the following two lines:
>
>printk(KERN_INFO "Message.\n");
>kprint_info("Message.");
>
>By dropping the lengthy macro (it's not like it's going to change
>while we're running anyway, so why not make it a part of the function
>name?) and the final newline, we actually end up with a net decrease
>in line length.
>
>I thought it would be nice to have something that looks familiar,
>since that would ease an eventual transition. klog is a valid
>alternative, but isn't kp a bit cryptic?

I'd rather fix up code to reduce its indent rather than
trying microoptimizations at the function name level!
