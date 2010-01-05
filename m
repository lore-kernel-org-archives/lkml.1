Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514Ab0AEVeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0AEVeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412Ab0AEVeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:34:14 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:42259 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0AEVeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mCcjvxFByJbnAYR3UVhcjlhl8euD/CxXMCgv1ySFUUyPU3qvWZVc6ZIOIrPIw5+ezA
         5fK2LO/S73EilHWWOFALjFsA+ryzi1Rtm9uGk/oFvXt94MQI81IIbaN46Z4UTstS3wgl
         7X3jfDyfI6TfKybqRrnV45alF5Nckwiel5V6Y=
MIME-Version: 1.0
In-Reply-To: <20100104143225.64a20bea.rdunlap@xenotime.net>
References: <20100104221345.GA7897@nb-core2.darkstar.lan>
	 <20100104143225.64a20bea.rdunlap@xenotime.net>
Date: Tue, 5 Jan 2010 22:34:11 +0100
Message-ID: <68676e01001051334h46bdb6cap83c2a75f00afeac4@mail.gmail.com>
Subject: Re: [PATCH/resend] Document awk requirements
From: Luca Tettamanti <kronos.it@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 11:32 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Mon, 4 Jan 2010 23:13:45 +0100 Luca Tettamanti wrote:
>
>> Gnu awk is required for generating generating
>> arch/x86/lib/inat-tables.c:
>>
>>  GEN     arch/x86/lib/inat-tables.c
>>  Error: Your awk doesn't support charactor-class.
>>
>> mawk doesn't work anymore.
>
> Hi,
> Did you try this patch?
>
> Subject: [tip:x86/urgent] x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

Ah, yes. mawk is once again able to build inat-tables.c. The patch can
be dropped.

thanks,
Luca
