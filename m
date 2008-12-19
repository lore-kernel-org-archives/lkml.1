Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbYLSQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbYLSQUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYLSQTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:19:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYLSQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:18:59 -0500
Message-ID: <494BC95F.1090000@zytor.com>
Date: Fri, 19 Dec 2008 08:18:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <ak@halobates.de>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
References: <20081218173506.GA29781@localhost.localdomain> <87vdtgz9h0.fsf@basil.nowhere.org>
In-Reply-To: <87vdtgz9h0.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> it would be better to find some way to fix up the debug information
> (perhaps this can be done with the right ld parameters?)
> 
> Changing defconfig doesn't really fix the problem because there will
> be still lots of kernel configurations around with
> CONFIG_RELOCATABLE=y
> 

Fixing the debug information is definitely necessary.  This is merely a
stopgap.  There has been a bug report about the relocatable kernel's
symbol information for a while, but there seems to be no forward
progress at fixing those.  I might end up taking a look at it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

