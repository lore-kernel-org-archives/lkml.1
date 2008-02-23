Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYBWMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYBWMpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYBWMpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:45:47 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36990 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYBWMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:45:46 -0500
Message-ID: <47C0159E.5020806@davidnewall.com>
Date: Sat, 23 Feb 2008 23:16:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: WANG Cong <xiyou.wangcong@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: Accessor macros vs reference counting
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <1203754478165-git-send-email-xiyou.wangcong@gmail.com> <1203754488669-git-send-email-xiyou.wangcong@gmail.com> <12037544991876-git-send-email-xiyou.wangcong@gmail.com> <1203754509934-git-send-email-xiyou.wangcong@gmail.com> <20080223090613.GJ16995@parisc-linux.org>
In-Reply-To: <20080223090613.GJ16995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Feb 23, 2008 at 04:14:08PM +0800, WANG Cong wrote:
>   
>> Use get_personality() macro instead of explicit reference
>> for parisc code.
>> -	if (personality(current->personality) == PER_LINUX32
>> +	if (personality(get_personality()) == PER_LINUX32
>>     
>
> Hm.  We have an interesting clash of conventions here.
>
> On the one hand, we have the java-style accessor convention.
> get_personality()/set_personality().
>   

Is get_personality() thought to be better than current->personality?  To
me, the latter seems more meaningful, and I'd rather see it than the former.
