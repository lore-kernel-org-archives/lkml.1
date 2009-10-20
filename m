Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZJTBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZJTBjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 21:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbZJTBjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 21:39:19 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:55603 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbZJTBjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 21:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l4NTNSO0x8LOJH75B2aBW5y6PjUt3VXfeuAfYNjShUo8tl7FeL62/1WVZtgj7DJVt3
         mj5OmceD+TT8rkLH8i0J0I0gKGNgs8M2Hj6IyLVuQ5jzt0w+Otdtec/R3oUWshhSBZoM
         N1jBQVdhDUh7tXE5TJluNAIrUDvqQBd9tZkLA=
MIME-Version: 1.0
In-Reply-To: <20091019125212.GA20983@aftab>
References: <20091019083329.GA7340@uhli> <20091019125212.GA20983@aftab>
Date: Tue, 20 Oct 2009 09:39:21 +0800
Message-ID: <3a3680030910191839g192514bbhfee4612d081ccd86@mail.gmail.com>
Subject: Re: [PATCH] amd64_edac: fix a wrong goto clause in amd64_edac.c
From: Li Hong <lihong.hi@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just caught by looking at the code. Thanks.

2009/10/19 Borislav Petkov <borislav.petkov@amd.com>:
> On Mon, Oct 19, 2009 at 04:33:29PM +0800, Li Hong wrote:
>> In amd64_edac_init(void) in amd64_edac.c, cache_k8_northbridges() is called
>> before pci_register_driver. If it fails, should exit with err directly.
>>
>> Signed-off-by: Li Hong <lihong.hi@gmail.com>
>
> Thanks, queued for the next .32 update.
>
> By the way, is this something you've caught by looking at the code
> or is it a condition you're hitting on a real system with a specific
> workload? If it is the second, I'd like to know more wrt to why
> cache_k8_northbridges() is failing in your particular case.
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Operating | Advanced Micro Devices GmbH
>  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
>  Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
>  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>  (OSRC)  | Registergericht München, HRB Nr. 43632
>
>
