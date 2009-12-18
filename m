Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZLRHtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZLRHtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZLRHtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:49:12 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61821 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZLRHtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:49:12 -0500
Message-ID: <4B2B33B2.9080900@ct.jp.nec.com>
Date: Fri, 18 Dec 2009 16:48:02 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: revert "config FS_JOURNAL_INFO"
References: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>	 <4B2AFF4C.5010100@ct.jp.nec.com> <b6fcc0a0912172325i34d214d3r11b3bfae7381547f@mail.gmail.com>
In-Reply-To: <b6fcc0a0912172325i34d214d3r11b3bfae7381547f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On 12/18/09, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>> So we never allow to make memory usage small with providing an option
>> to remove unused area, right?
> 
> We certainly allow this if it results in zero loss in functionality.

Thanks for clarifying this topic.

If you don't mind could you please tell me what zero loss is?
I don't think I could get it exactly.

Is it OK that removing journal_info if !CONFIG_BLOCK?

> 
>> If I want to reduce memory usage by this way, should I keep
>> this kind of patches out of tree?
> 
> Certainly nobody can prohibit you from keeping patch out of tree.
> But if you want something mainlinable, moving ->journal_info
> to fs-specific data structures should do the trick. Or something.

Thanks for the advice, I'll look at this.

Thanks,
Hiroshi
