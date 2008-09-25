Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYIYAT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYIYAT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYIYATO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:19:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:20491 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYIYATN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xmy5cqbWJrdXmFNKu/3Q+3UjhSyMx7isnZndhHyZ2bJBcYZbMJl/43cmvmgyvx7WQK
         Vh/0aHu88q5lNG6AvnXeXRuArSne1k9n4mXQBtQIJbodVvKkpcw9MWHbciFKEv7kcLp/
         uIDvZGm+KnnX6RUibd8ob6nN/3QAFB4t3R6ug=
Date: Thu, 25 Sep 2008 08:19:06 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alok kataria <alokkataria1@gmail.com>, Yan Li <elliot.li.tech@gmail.com>,
       Cristi Magherusan <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, Zachary Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925001906.GC21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost> <20080924142322.GA21049@yantp.cn.ibm.com> <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com> <48DA68FF.3030202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DA68FF.3030202@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:21:19AM -0700, H. Peter Anvin wrote:
> Alok kataria wrote:
>>
>> Btw, are you pushing these patches for the 2.6.27 release ? If this is
>> for the x86 tree(2.6.28) i think we should hold on, until i post the
>> proposal for the cpuid patches, so that we can unify this and have a
>> generic way to detect on which hypervisor are we running .
>>
>
> I don't think there is any way in hell this is going into 2.6.27.
>
> For it to make 2.6.28 it will have to be ready very soon.

I'd like to see it in 2.6.28 to fix the false warning here. I'll take
several comments here and post a improved patch soon (changing code is
fast but testing them on VMs here with different configurations are
time-consuming). But I think people could just start to test this
version of patch since further change will be mostly cosmetic, FWIW.

-- 
Li, Yan
