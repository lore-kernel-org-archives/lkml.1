Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZLNHsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZLNHsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZLNHsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:48:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZLNHsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:48:05 -0500
Message-ID: <4B25EE41.4020809@redhat.com>
Date: Mon, 14 Dec 2009 15:50:25 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, gcosta@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove usedac in feature-removal-schedule.txt
References: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> The reason of removal, "replaced by allowdac and no dac combination"
> is incorrect. There is no way to do the same thing with "allowdac" and
> "nodac" combination.
> 
> The usedac option enables us to stop via_no_dac() setting forbid_dac
> to 1. That is, someone who uses VIA bridges can use DAC with this
> option even if some of VIA bridges seem to be broken about DAC.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Hi,

This sounds reasonable for me.

Acked-by: WANG Cong <amwang@redhat.com>

> ---
>  Documentation/feature-removal-schedule.txt |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 2a4d779..eb2c138 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
>  
>  ---------------------------
>  
> -What:	usedac i386 kernel parameter
> -When:	2.6.27
> -Why:	replaced by allowdac and no dac combination
> -Who:	Glauber Costa <gcosta@redhat.com>
> -
> ----------------------------
> -
>  What: print_fn_descriptor_symbol()
>  When: October 2009
>  Why:  The %pF vsprintf format provides the same functionality in a

