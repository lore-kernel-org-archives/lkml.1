Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbZENDEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbZENDEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZENDEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:04:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58338 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbZENDEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rH7irAloAMuJ0W0JrUqYnDOhaHHZIyKKeQPx9v+mNuNnS1FGKFNMlic3wMDrkhequj
         ivPmIgMLi4PzyhestA8UwEolmsQ6natmjA8otIc+hYQrVmiWnjOo8R1FqxUo2+X4jbqS
         U3K2tjztel9fBHPmAqBpeU6HI88tI1HWzFUqM=
MIME-Version: 1.0
In-Reply-To: <1242251973.3364.20.camel@localhost.localdomain>
References: <1242251841.3364.17.camel@localhost.localdomain>
	 <1242251973.3364.20.camel@localhost.localdomain>
Date: Thu, 14 May 2009 07:04:34 +0400
Message-ID: <aa79d98a0905132004h1d249986kde62dd5a5a5609ff@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: apic/apic.c native_apic_write_dummy() should be 
	static
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/09, Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/apic/apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d6d4ffd..966783b 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -243,7 +243,7 @@ static int modern_apic(void)
>   * bare function to substitute write operation
>   * and it's _that_ fast :)
>   */
> -void native_apic_write_dummy(u32 reg, u32 v)
> +static void native_apic_write_dummy(u32 reg, u32 v)
>  {
>  	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
>  }
> --
> 1.6.0.6
Hi Jaswinder,

Check please latest tip numa branch. I thought Yinghai already fixed this nit.
