Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZCLPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZCLPCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZCLPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:02:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbZCLPCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:02:22 -0400
Message-ID: <49B923E9.6020603@zytor.com>
Date: Thu, 12 Mar 2009 08:02:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, jeremy.fitzhardinge@citrix.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
References: <49B8F3D4.76E4.0078.0@novell.com> <20090312105426.GC30204@elte.hu> <49B8FF3E.76E4.0078.0@novell.com> <20090312113520.GA8353@elte.hu> <49B9056F.76E4.0078.0@novell.com>
In-Reply-To: <49B9056F.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> See:
>>
>>  http://lkml.org/lkml/2008/10/28/67 
> 
> Thanks. Would certainly be helpful to put into Documentation/ if this is
> meant to be more than just a personal requirement of yours.

It's something we started with in the x86 tree (it came out of a long
discussion Ingo and I had about how to filter patches.)  It's not like
we can impose this workflow on others, but it has been *way* useful: a
patch with a *meaningful* "Impact:" line typically needs less than a
third of the human time than one without -- simply because it forces the
submitter to think about it.

Similarly "Fix foo" is not a complete description in any way.  Why was
foo broken in the first place?

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

