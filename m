Return-Path: <linux-kernel-owner+w=401wt.eu-S1423016AbXBAVHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423016AbXBAVHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423018AbXBAVHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:07:11 -0500
Received: from terminus.zytor.com ([192.83.249.54]:42656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423017AbXBAVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:07:09 -0500
Message-ID: <45C25654.8030003@zytor.com>
Date: Thu, 01 Feb 2007 13:06:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Mark Huang <mlhuang@cs.princeton.edu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org> <200702022252.26317.caglar@pardus.org.tr>
In-Reply-To: <200702022252.26317.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
> 
> 01 Şub 2007 Per tarihinde, Linus Torvalds şunları yazmıştı: 
>> I've added some initramfs people to the Cc: in case somebody has better
>> ideas, but in the absense of that, it really would be good to do that
>> bisection. Also, you might want to double-check that your cpio actually
>> generates a good initramfs image (it that it's not some user-mode upgrade
>> that caused it to stop working).
> 
> I started bisect with 2.6.19 and ended up with 2.6.20-rc7 and every step 
> worked without a problem with problematic initramfs script, so i think that 
> was a compilation failure or something else but currently 2.6.20-rc7 works 
> without a problem, so please ignore that one, sorry for noise...
> 

OK, well, if it crops up again, please holler.  It could be a 
nondeterministic bug.

	-hpa

