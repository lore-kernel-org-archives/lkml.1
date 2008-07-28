Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYG1ViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYG1ViA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYG1Vhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:37:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:8386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYG1Vhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wwrBUbDwEMN6UqzrkWB/kwCx8ucVXdmAPR8oyMXzcfIK/vqmlON3rn80X7Sl3I1HJI
         gYpfIhBtJWZl1E1cMYAHqWmj8efw99/xzR9YY/J5lS9EFO3zr4XASVMlXAHZRewQiKm/
         S2mDLdBjTZ7hYUhrglrOiTn70aCyNn3xClCgQ=
Message-ID: <6b53b1990807281437l707be573n3be4d85feb033c63@mail.gmail.com>
Date: Mon, 28 Jul 2008 18:37:44 -0300
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/24] x86: arch/x86/kernel/ cleanups
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <20080728212052.GB9986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <gustavo@las.ic.unicamp.br>
	 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <20080728212052.GB9986@elte.hu>
X-Google-Sender-Auth: f039612515773454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 6:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:
>
>> Ingo,
>>
>> I removed many extra whitespaces and tabs from arch/x86/kernel/
>
> hm, we tend to do a full cleanup of files we touch for style
> cleanup.
>
> You can check some style errors via:
>
>  scripts/checkpatch.pl --file arch/x86/kernel/alternative.c
>
> but it also makes sense to look at the file and figure out places that
> look ugly.
>
>>       x86: kernel/alternative.c cleanup
>
> total: 4 errors, 15 warnings, 4 checks, 540 lines checked
>
>>       x86: kernel/apm_32.c cleanup
>
> total: 6 errors, 27 warnings, 5 checks, 2416 lines checked
>
> [ etc. ]
>
> If we did each style problem separately we'd be generating over 1
> million commits for the entire tree - that's not feasible. So we go per
> file and once a file has been cleaned up, we keep it clean.
>
> Note, checkpatch errors can be false positives occasionally, and not all
> warnings have to be fixed all the time - ask if unsure about whether to
> fix something or not.
>
> It's also useful to check that the .o's are unchanged after a cleanup.
> You can see commits that do that, for example:

Right. I will do this.

Thanks, Ingo.

>
>  commit d4413732b54a17684e48fbb4b52fade5bf965b5d
>  Author: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
>  Date:   Tue Feb 19 23:51:27 2008 +0100
>
>    x86: coding style fixes to arch/x86/oprofile/op_model_athlon.c
>
>    The patch fixes 33 errors and a few warnings reported by checkpatch.pl
>
>    arch/x86/oprofile/op_model_athlon.o:
>       text    data     bss     dec     hex filename
>       1691       0      32    1723     6bb op_model_athlon.o.before
>       1691       0      32    1723     6bb op_model_athlon.o.after
>    md5:
>    c354bc2d7140e1e626c03390eddaa0a6  op_model_athlon.o.before.asm
>    c354bc2d7140e1e626c03390eddaa0a6  op_model_athlon.o.after.asm
>
>    Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>        Ingo
>



-- 
----------------------------------------------
Gustavo Fernando Padovan
Engenharia de Computação 2006
LAS - Laboratório de Administração e Segurança de Sistemas
Instituto de Computação - UNICAMP

gfpadovan@gmail.com
ra061316@students.ic.unicamp.br
pao@jabber.org
-------------------------------------------

Seja Livre, use Software Livre
