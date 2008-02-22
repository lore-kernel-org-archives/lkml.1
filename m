Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbYBVFPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbYBVFPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934588AbYBVFLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:11:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56728 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755744AbYBVFL2 (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:11:28 -0500
Message-ID: <47BE5AB0.7060206@sgi.com>
Date: Fri, 22 Feb 2008 16:16:32 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com> <47BE571E.4000802@garzik.org>
In-Reply-To: <47BE571E.4000802@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Lachlan McIlroy wrote:
>>     Remove empty file fs/xfs/Makefile-linux-2.6.
> 
> Already in the upstream kernel...
That's funny - I didn't see this change come through.  Oh well... thanks.

> 
> 
>> commit 1803f3389b7ac9ed33ea561b3b94e22e2864a95d
>> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
>> Date:   Wed Feb 20 19:55:09 2008 -0800
>>
>>     Remove empty file remnants that were left in the tree by mistake
>>         Noted by various people (Sam, Jeff, Roland..)
>>         Commit 58b7983d15a422d9616bdc4e245d5c31dfaefbe2 intended to 
>> remove the
>>     xfs "Makefile-linux-2.6" file, but it was mistakenly still left in 
>> the
>>     tree as a empty file, and would cause git to correctly complain 
>> about a
>>     tracked file being removed after a "make distclean" (which removes 
>> empty
>>     files as garbage).
>>         And the asm-x86/desc_64.h file was supposed to be removed by 
>> commit
>>     c81c6ca45a69478c7877b729af1942d2b80ef582, but instead stayed around
>>     containing just a single newline.
>>         Get rid of them both properly.
>>         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
