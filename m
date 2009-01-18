Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbZARFJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbZARFJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZARFJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:09:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:42694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZARFJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:09:04 -0500
Message-ID: <4972B967.4010606@kernel.org>
Date: Sun, 18 Jan 2009 14:08:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>	 <1232115396-26367-1-git-send-email-brgerst@gmail.com>	 <1232115396-26367-2-git-send-email-brgerst@gmail.com>	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>	 <4972B6D9.4080101@kernel.org> <73c1f2160901172105p8ba1aa4v708e746d5548a79d@mail.gmail.com>
In-Reply-To: <73c1f2160901172105p8ba1aa4v708e746d5548a79d@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 05:08:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Brian Gerst wrote:
>> Also, as pda field name, irqstackptr might be fine but wouldn't it be
>> better to rename it to at least irq_stack_ptr as this change requires
>> touching every users anyway?
> 
> I kept the same name unless it would conflict with something.  If you
> want to rename it, it should be a separate patch.

Sure, that's an option too but it might as well be done when making
those percpu variables.  I don't really see why those two changes
should be separate.  There isn't any reason why they shouldn't be
separate either but if you're already mucking around every user...

Thanks.

-- 
tejun
