Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYLDLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYLDLZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYLDLZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:25:24 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:16086 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYLDLZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vIlmwI/pFevkP79NXBk05PPgqVVaeOLykuWxakhvQeeG8xZLTv6BrrymYIvciLqwq+
         P/PatfdXvliIHI8Tveye5oR0Dfp+vRK7v92RGSsSpQqfuxO93AbyZy2wS1wyKAftn5YE
         50rekgMXd6UEbkin6ZUpHvRTN3R+HqSKqnGxs=
Message-ID: <2375c9f90812040325l6c340d5qbb527bd55c04fa53@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:25:21 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] ipc: fix warning of not used variable
Cc: "Jianjun Kong" <jianjun@zeuux.org>, akpm@linux-foundation.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081204101354.GC18708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204010026.GC17445@ubuntu> <20081204101354.GC18708@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 10:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jianjun Kong <jianjun@zeuux.org> wrote:
>
>>
>> fix this warning:
>> ipc/ipc_sysctl.c:39: warning: 'ipc_auto_callback' defined but not used
>> ipc_auto_callback() just called when CONFIG_PROC_FS was defined.
>>
>>
>> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
>> ---
>>  ipc/ipc_sysctl.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> NAK.
>
> the proper fix, considering all the possibilities, is below.
>

Already fixed in -mm, please do search lkml archive before posting.

Thanks.
