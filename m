Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYAAVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYAAVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYAAVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:24:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYAAVYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:24:23 -0500
Message-ID: <477AAE6E.8080305@zytor.com>
Date: Tue, 01 Jan 2008 13:19:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de, mingo@redhat.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
References: <200712311312.46450.vapier@gentoo.org> <20080101174708.GA25089@infradead.org>
In-Reply-To: <20080101174708.GA25089@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Dec 31, 2007 at 01:12:45PM -0500, Mike Frysinger wrote:
>> Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather than
>> asm in its code.
> 
> The correct fix is to not export it to userspace.

Unfortunately, it's historically been provided, for over 15 years.  It's 
also trivial to export, without funnies, and it's *useful* to userspace, 
as it provides an interface sorely lacking from the stock libc interfaces.

So please do provide it, even though it's arguably the wrong thing.  The 
downside is worse.

	-hpa
