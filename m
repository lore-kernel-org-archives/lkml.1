Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYDHEhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYDHEhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYDHEhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:37:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYDHEhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:37:00 -0400
Message-ID: <47FAF593.4020503@zytor.com>
Date: Mon, 07 Apr 2008 21:33:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bootmem allocator
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu>	 <87iqytqwl7.fsf@basil.nowhere.org>	 <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com> <aa79d98a0804072114q300e336eoec814ad6053c934d@mail.gmail.com>
In-Reply-To: <aa79d98a0804072114q300e336eoec814ad6053c934d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> I think it would be a good idea ;) Btw maybe would be better to call
> memset on the code witch relies on "clear" memory explicitly? So we will
> clear memory allocated *only* if we really need this.
> 

Are there any users of bootmem which will allocate a significant amount 
of memory and don't need it zeroed?

	-hpa
