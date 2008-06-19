Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYFSKvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYFSKvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbYFSKvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:51:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:53512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYFSKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YwSROg+eQBDp0szmd5hryK6O8FICr/1+p6UAAX380kzZw5fBE3bChGCfi0IYVMOGPT
         Zsr0sZoF+AM6wGb37Z2T30FOv3+zFSoIfbFBpNLRyjc3VqvoeC4Wtyy6Z8lGUrMXJBVG
         2PS03InSZSlPNE9RRiXMwOQaoq+UbZ0pLTqKA=
Message-ID: <aa79d98a0806190351r9bf1c75w6c46b0a84febac58@mail.gmail.com>
Date: Thu, 19 Jun 2008 14:51:30 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] typo CONFIX -> CONFIG
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20080619095830.GE15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213657148-5263-1-git-send-email-gcosta@redhat.com>
	 <20080619095830.GE15228@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 1:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Glauber Costa <gcosta@redhat.com> wrote:
>
>> ---
>>  arch/x86/kernel/nmi.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
>> index 07cf17f..3775463 100644
>> --- a/arch/x86/kernel/nmi.c
>> +++ b/arch/x86/kernel/nmi.c
>> @@ -69,7 +69,7 @@ static inline unsigned int get_nmi_count(int cpu)
>>
>>  static inline int mce_in_progress(void)
>>  {
>> -#if defined(CONFIX_X86_64) && defined(CONFIG_X86_MCE)
>> +#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
>
> applied to tip/x86/nmi - thanks Glauber. [ Someone's been reading too
> many Goscinny comics ;) ]
>
>        Ingo
>

Oh my, thanks! (putting the comics behind the back by trying to
show that is not my fault ;-)
