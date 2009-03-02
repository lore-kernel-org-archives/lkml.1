Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZCBCvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZCBCvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbZCBCvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:51:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:4241 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZCBCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=X2eLtJGSMxts7FSDXqq9VwJO+AfEfZfxpdDQ3+9nmrDxhheqRB+G2GxzwfO5hDPS6y
         ljpcERf/+HsSGgsECMA8fDw3Y6JPBo774ZT9hPtPJEqX09NdXXaKzcJepws0LogdKXty
         sr1GkZf7Cdc3JG4PSMpfbeONKv7+aWp48wiwI=
MIME-Version: 1.0
In-Reply-To: <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
Date: Sun, 1 Mar 2009 18:51:32 -0800
X-Google-Sender-Auth: 675f8d447f79e2e1
Message-ID: <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Yinghai Lu <yinghai@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 6:37 PM, Huang Ying <ying.huang@intel.com> wrote:
>> so 64bit could use ioremap_cache() too?
>> we may keep 32bit and 64bit a bit consistent.
>
> If we use ioremap_cache(), kexec runtime service will not work in kexec
> situation, which needs EFI runtime memory area to be mapped at exact
> same location across kexec. I think we should support kexec if possible.


sure.

please don't touch max_low_pfn_mapped, because some range may not
directly mapped under those efi run-time code

YH
