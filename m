Return-Path: <linux-kernel-owner+w=401wt.eu-S965972AbXCFROn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972AbXCFROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965971AbXCFROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:14:43 -0500
Received: from terminus.zytor.com ([192.83.249.54]:45159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965974AbXCFROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:14:42 -0500
Message-ID: <45EDA15F.5090805@zytor.com>
Date: Tue, 06 Mar 2007 09:14:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org> <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com> <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com> <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com> <Pine.LNX.4.64.0703060853050.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703060853050.5963@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
>> However, this could be optimized.  I think right now sprintf() uses a generic
>> divide-by-base, but a divide by 8 and 16 can of course be handled with a
>> shift, and divide by 10 can be replaced with a multiplication by
>> 0x1999999999999999ULL on most architectures.
> 
> Nope. You need both the result of the division *and* the remainder, and 
> you can't do that with a single multiply.

Oh, right.  *D'oh*.

	-hpa
