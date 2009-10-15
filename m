Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZJOFMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZJOFMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZJOFMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:12:37 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:42052 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZJOFMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oWl5WyMEc4f0LHXkh3Wdg6VWDWKfOfJFNwc+smLFVRtKqbeQLkqpdvmSXkSqgakKFo
         7BdSKYOtoSPel/Z9i3BnGrrMianJt73fdr/2ad2ETvXDoNEtfpjj67d0cO4hT+lX4usE
         GjWF0QjTqIz8vzopSM4I50uT4JIDgF/HyCckc=
MIME-Version: 1.0
In-Reply-To: <20091014171240.49d0963f@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu> <20091012131528.GC25464@elte.hu> 
	<20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> 
	<20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> 
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain> 
	<20091014153458.05e31db6@marrow.netinsight.se> <20091014154124.5d9c366e@marrow.netinsight.se> 
	<20091014171240.49d0963f@marrow.netinsight.se>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 15 Oct 2009 10:41:39 +0530
Message-ID: <ce9ab5790910142211v54c70deet8c5732cfccb01914@mail.gmail.com>
Subject: Re: [PATCH v6 5/5]: mtdoops: refactor as a kmsg_dumper
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 8:42 PM, Simon Kagstrom
<simon.kagstrom@netinsight.net> wrote:
> On Wed, 14 Oct 2009 15:41:24 +0200
> Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
>
>> -static void __exit mtdoops_console_exit(void)
>> +static void __exit mtdoops_exit(void)
>>  {
>>       struct mtdoops_context *cxt = &oops_cxt;
>>
>>       unregister_mtd_user(&mtdoops_notifier);
>> -     unregister_console(&mtdoops_console);
>>       kfree(cxt->name);
>
> The kfree should go as well since cxt->name is no longer allocated. I'll
> await further comments and send a new patch tomorrow.
>
Help description for 'MTD_OOPS' in Kconfig needs update after this
patch. Are you planning to add a patch for same in this series?

-vimal

> // Simon
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>
