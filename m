Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXLOXFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXLOXFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbXLOXFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:05:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbXLOXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:05:02 -0500
Message-ID: <47645D66.4020506@zytor.com>
Date: Sat, 15 Dec 2007 15:04:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz>
In-Reply-To: <20071215230036.GF2434@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>
>> this is also something for v2.6.24 merging.
> 
> As much as I like this patch, I do not think it is suitable for
> .24. Too risky, I'd say.
> 

No kidding!  We're talking about removing a hack that has been 
successful on thousands of pieces of hardware over 15 years because it 
breaks ONE machine.

If this should be done at all it should be done in the most careful 
manner possible.  2.6.25 would be an aggressive schedule.

	-hpa
