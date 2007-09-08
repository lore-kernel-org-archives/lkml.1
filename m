Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXIHUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXIHUiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 16:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXIHUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 16:38:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXIHUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 16:38:04 -0400
Message-ID: <46E3080E.9060403@zytor.com>
Date: Sat, 08 Sep 2007 15:37:34 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
References: <200709071526.51169.jesse.barnes@intel.com> <200709080557.36021.nickpiggin@yahoo.com.au> <200709081219.43662.ak@suse.de> <200709080632.05389.nickpiggin@yahoo.com.au>
In-Reply-To: <200709080632.05389.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> smp_rmb() should not need to do anything because loads are done
> in order anyway. Both AMD and Intel have committed to this now.
> 
> The important point is that they *appear* to be done in order. AFAIK,
> the CPUs can still do speculative and out of order loads, but throw
> out the results if they could be wrong.

Is there anything even semiofficial from VIA?  Not that the x86 
architecture isn't pretty much definable as the AMD-Intel consensus...

	-hpa

