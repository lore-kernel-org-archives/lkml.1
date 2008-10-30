Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYJ3ULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYJ3ULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJ3ULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:11:05 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44860 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbYJ3ULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:11:04 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 16:11:04 EDT
Message-ID: <490A12BA.5010601@sgi.com>
Date: Thu, 30 Oct 2008 13:02:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1]: SGI x86 UV: Fix compile error in uv_hub.h
References: <4909FDEF.2050803@sgi.com> <20081030183924.GB17822@elte.hu>
In-Reply-To: <20081030183924.GB17822@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Subject: SGI x86 UV: Fix compile error in uv_hub.h
>>
>> Fix compile errors of files that include asm/uv/uv_hub.h but do
>> not include linux/timer.h.
>>
>> Based on linux-next.
>>
>> Signed-of-by: Mike Travis <travis@sgi.com>
>> ---
>>  arch/x86/include/asm/uv/uv_hub.h |    1 +
>>  1 file changed, 1 insertion(+)
> 
> does not affect mainline currently, correct? Nevertheless i queued it 
> up in x86/urgent as it's an obviously correct dependency fix.
> 
> 	Ingo

The error popped up on linux-next this morning (in our daily build.)

I'm not sure how it got in there, I think a quilt refresh did it (the
original file had the include so it didn't see the difference when
writing the patch file.)

Thanks,
Mike
