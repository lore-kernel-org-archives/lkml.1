Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZJGJTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZJGJTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZJGJTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:19:04 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:55881 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZJGJTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HhD5XRhwZPSyIKEYtU7vOITMTbbFiAA2JLMMQe0+eXzXavZl5njSZLrEocLHOh+7m0
         XAQ5y5k6J8blgQTjCx9eWVKHsvpxfra2ujmtbJ1ViMbqqW9JnG8JpbieoiSfao+mVY6c
         dNSH4QfHEAGmYsg2M7j/eqJk6DlrlY+ykm8So=
MIME-Version: 1.0
In-Reply-To: <20091005094102.1385b418.rdunlap@xenotime.net>
References: <1254732163-3509-1-git-send-email-anuj.aggarwal@ti.com>
	 <20091005094102.1385b418.rdunlap@xenotime.net>
Date: Wed, 7 Oct 2009 14:48:26 +0530
X-Google-Sender-Auth: 26099c8864bf1edf
Message-ID: <618f0c910910070218q496eeb9dgf200ffd5d6583aef@mail.gmail.com>
Subject: Re: [PATCH v2] SDMA: Fixing bug in omap_dma_set_global_params()
From: Venkatraman S <svenkatr@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 10:11 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Mon,  5 Oct 2009 14:12:43 +0530 Anuj Aggarwal wrote:
>
>> Argument tparams was not being used to program
>> global register GCR.HI_THREAD_RESERVED. This patch fixes the same.
>>
>> Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
>> ---
>>  arch/arm/plat-omap/dma.c |   15 +++++++++------
>>  1 files changed, 9 insertions(+), 6 deletions(-)
>
>
> Hi,
> Someone please convert all of this source file to correct kernel-doc notation.
>
> Thanks.
>

I now have this on my TODO list. As a bug fix, shouldn't this be
pulled in and the doc updates for all the functions can be done as a
separate patch ?
Anuj,
 Can you please correct the comments for this function to proper
format along with your changes ?

Thanks,
Venkat.
