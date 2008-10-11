Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYJKOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYJKOPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJKOPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:15:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYJKOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:15:10 -0400
Message-ID: <48F0B40A.8080007@zytor.com>
Date: Sat, 11 Oct 2008 07:11:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] fastboot tree for v2.6.28
References: <20081010003241.GA23940@elte.hu> <alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org> <20081010154929.6ec201fe@infradead.org> <20081011064712.GA25451@elte.hu> <20081011004840.5ad62ce0.akpm@linux-foundation.org> <20081011082845.GA28715@elte.hu>
In-Reply-To: <20081011082845.GA28715@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> a config option is definitely useful for users and distros. Having the 
> boot option is a good idea. Arjan, i thought we had a fastboot=0/1 boot 
> option but i cannot find it - could you please add it?
> 

In general, boolean options should be fastboot/nofastboot.  We have 
plenty of inconsistency in that area, but we really don't need to add more.

	-hpa
