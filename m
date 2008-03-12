Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYCLPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYCLPF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYCLPFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:05:21 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53440 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYCLPFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:05:20 -0400
From: Stephan Diestelhorst <langer_mann@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Wed, 12 Mar 2008 16:04:04 +0100
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
References: <200803051559.09962.langer_mann@web.de> <200803102226.39044.langer_mann@web.de> <20080311093903.GS25110@elte.hu>
In-Reply-To: <20080311093903.GS25110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121604.05065.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX18mhcUD/W7A8XKFiaka+N9AjfZ+FY/CT0nda+hD
	Tdnb+N/MXpX+GIb0xN+gmOQKZm9HuRBYV5t9a9HXvohDdTm/hh
	le+UZbYwQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I've applied your patch to  x86.git. 

Many thanks!

> Do you think it's 2.6.25 material? I'm inclined to have it in  
> the 2.6.26 bucket. We could do your first, minimal fix in 2.6.25 and do 
> this second, full fix in 2.6.26.

I am not familiar with the policies regarding the time-frame for
inclusion. So I guess the decision is up to you. I feel that the
changes are fairly small (at least for the first patch) so perhaps
splitting the release as you suggested allows people to get more
confidence in the larger patches with the clobbers and manual ebp
push/pop.

Doing this one step after the other has the additional benefit of
havinga fix for the core problem in fairly soon, so I can continue
using prebuilt distro kernels again, soon. :-) ( I know. I'm just lazy
sometimes. )

Apart from that: Feel free to do as you like, after all this code is
GPL.

Kind regards,
  Stephan
