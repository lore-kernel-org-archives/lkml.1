Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYG1ODP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYG1ODP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYG1ODA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:03:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYG1OC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:02:59 -0400
Message-ID: <488DD176.50600@zytor.com>
Date: Mon, 28 Jul 2008 10:02:30 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joro@8bytes.org>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu> <488DECD9.76E4.0078.0@novell.com>
In-Reply-To: <488DECD9.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> 
>> Firstly, 64-bit does not use a task gate for double faults anymore. (but 
>> uses a separate IST stack for double faults)
> 
> Sure - because there are no task gates on 64-bit.
> 

What we're doing here is really using task gates to emulate IST anyway.

	-hpa
