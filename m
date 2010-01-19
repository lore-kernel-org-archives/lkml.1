Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625Ab0ASOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0ASOZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234Ab0ASOZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:25:23 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38452 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0ASOZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LqhxH3Ge/wlH0xuduzI4OLOd303kZq2aLYEYDOIGyNILN8y86+GJzv2Sp8+NVBxUD5
         eAxUJOFbfj7WfoeM/9MAiuPVvLXzWkMLmdNJBv671eNoGqAl/bUaDAKQ62ADNvsa6fpY
         UnFTTgIPXkKlLjk8sdKYQibQJZt0FEvQS7y3c=
MIME-Version: 1.0
In-Reply-To: <20100115160602.f1523a68.akpm@linux-foundation.org>
References: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
	 <20091127050022.15251.43017.sendpatchset@rxone.opensource.se>
	 <20100115160602.f1523a68.akpm@linux-foundation.org>
Date: Tue, 19 Jan 2010 23:25:18 +0900
Message-ID: <aec7e5c31001190625x2b0629f7xdef38dc6edc43586@mail.gmail.com>
Subject: Re: [PATCH 03/03] mmc: Balance tmio-mmc cell enable()/disable() calls
From: Magnus Damm <magnus.damm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       ian@mnementh.co.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pierre@ossman.eu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 9:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 27 Nov 2009 14:00:22 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds cell->disable() calls to the tmio-mmc
>> probe() error handling and the remove() function.
>>
>
> This patch still doesn't apply due to linux-next changes which never
> got merged into 2.6.33-rcX.

Good news is that the linux-next issue seems solved now thanks to help
from Samuel Ortiz.

> If you think it should go into 2.6.33 then please redo a patch against
> mainline and we'll cheerily trash the problematic stuff in linux-next.

Nah, this patch is not urgent. It may also break other platforms, so I
prefer to resend it later.

Thanks,

/ magnus
