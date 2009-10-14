Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZJNHxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZJNHxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZJNHxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:53:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47191 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZJNHxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vzchFRtpPmKOFf66sBQmhYFRiebD9XYxUhuI5IyQu86q4DXOgo/uCiBcRK7616E7/f
         nGP53mWgn70oxcOwgLfNtH9lUV/rX1MGwnDcBcS3eIyPV47bPKV2lZjL29xNlRCgHD3l
         VKDceZlJG0DnF7/TbDYtb78FQONofJDu5ItCY=
MIME-Version: 1.0
In-Reply-To: <20091014071217.GL784@elte.hu>
References: <20091013200702.019870576@openvz.org>
	 <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu>
Date: Wed, 14 Oct 2009 11:51:43 +0400
X-Google-Sender-Auth: 8fa1f57cd877fd2a
Message-ID: <aa79d98a0910140051k15cbaa42ib82f62e0dd400ed6@mail.gmail.com>
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic 
	setup option
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>> In case if a system has a large number of cpus printing apics
>> contents may consume a long time period.
>>
>> We limit such an output by 1 apic by default. But to have an
>> ability to see all apics or some part of them we introduce
>> "show_lapic" setup option which allow us to limit/unlimit
>> the number of APICs being dumped.
>>
>> Example: apic=debug show_lapic=5, or apic=debug show_lapic=all
>>
>> Also move apic_verbosity checking upper that way so helper routines
>> do not need to inspect it at all.
>>
>> Suggested-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |   47
>> +++++++++++++++++++++++++++--------------
>>  1 file changed, 32 insertions(+), 15 deletions(-)
>
>> +__setup("show_lapic=", setup_show_lapic);
>
> Note: new __setup() functions need an entry in
> Documentation/kernel-parameters.txt as well.
>
> 	Ingo
>
Will update today evening. Thanks!
