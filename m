Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797Ab0ADTss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0ADTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125Ab0ADTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:48:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:51506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0ADTsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:48:46 -0500
Message-ID: <4B4245BB.5070302@kernel.org>
Date: Mon, 04 Jan 2010 11:47:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2/2] x86: get more exact nr_irqs
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	<4B398ECD.1080506@kernel.org>	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	<4B415E73.1050801@kernel.org> <4B41918D.3000605@kernel.org>	<m1fx6lizc3.fsf@fess.ebiederm.org>	<86802c441001041103s5abd6d3ai4e6ccbfc68323f3c@mail.gmail.com> <m1bph9he9m.fsf@fess.ebiederm.org> <4B4241E2.1020008@zytor.com>
In-Reply-To: <4B4241E2.1020008@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 11:30 AM, H. Peter Anvin wrote:
> On 01/04/2010 11:16 AM, Eric W. Biederman wrote:
>>
>> If we care about memory use efficiency let's replace irq_desc_ptrs
>> with a rbtree or a radix_tree.  Something that moves the memory use
>> penalty onto those machines that have a lot of irqs.
>>
> 
> rbtree doesn't make much sense for something that is addressed by index,
> and doesn't need to answer questions of the form "give me the highest
> member <= X".  A hash table or radix tree makes sense, depending on the
> expected sparseness of the index.

will check if we can use radix with it like powerpc

YH
