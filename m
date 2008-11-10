Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYKJJlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYKJJlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYKJJlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:41:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:51951 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYKJJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eTUcHtP6d1GlGlAtditEgsIC+62CKJ0O44XtEn7CJnVmBUeFDXgW4WRdswYfkO94ZV
         6wkswsQg+ko3uEE4b9vMP59iW46+L7eqHsDWEPw/qKcNKRbj1OC7eHwLDeBWdgNDTqXp
         v3TG35k7hWrMBBfHuKlADrEaDmSzOC9gEAnJk=
Message-ID: <86802c440811100141k29d8f01dg7d279c3a0f85a184@mail.gmail.com>
Date: Mon, 10 Nov 2008 01:41:45 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] fix smp generic helper voyager breakage
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jens Axboe" <Jens.Axboe@oracle.com>
In-Reply-To: <20081110093516.GK22392@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225400980.19324.24.camel@localhost.localdomain>
	 <20081030215421.GG30303@elte.hu>
	 <1225404368.19324.49.camel@localhost.localdomain>
	 <20081030222111.GA18600@elte.hu>
	 <1226253194.19841.9.camel@localhost.localdomain>
	 <20081110093516.GK22392@elte.hu>
X-Google-Sender-Auth: 8766decccba2d149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 1:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>
>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date: Wed, 29 Oct 2008 14:53:06 -0500
>> Subject: [VOYAGER] fix generic smp helpers non compile
>
> hm, i reported a bug to you with this patch on Oct 30.
>
>> commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Thu Jun 26 11:21:34 2008 +0200
>>
>>     Add generic helpers for arch IPI function calls
>>
>> didn't wire up the voyager smp call function correctly, so do that
>> here.  Also make CONFIG_USE_GENERIC_SMP_HELPERS a def_bool y again,
>> since we now use the generic helpers for every x86 architecture.
>>
>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>> ---
>>  arch/x86/Kconfig                    |    5 ++++-
>>  arch/x86/mach-voyager/voyager_smp.c |   16 ++++++++++++++--
>>  2 files changed, 18 insertions(+), 3 deletions(-)
>
> no indication in the changelog whether that bug i reported got fixed -
> did it? (i suspect it did, but not sure)

should fix some voyager_smp.c compliing...

YH
