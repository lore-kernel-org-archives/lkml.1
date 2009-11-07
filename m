Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZKGLng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZKGLng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZKGLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:43:36 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62236 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZKGLnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:43:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FwAop3UzmNaJ3UJeNjnOWz7SGPGHn9vfLhAGQyAckB6mJ3ysRGcXoXB+l0ol6fD3mx
         TIgpjYXsoimTksunJ2pQDbiMARMy7zIeCWxGNFYb1NjJK3GP/J99h7YaDO03HBMJRdgi
         XeJRkjtJaNPTxUj5eGi0kc7D9nJpnmm5D/bTU=
MIME-Version: 1.0
In-Reply-To: <4AF46B90.8010905@sgi.com>
References: <1257192776.5941.11.camel@dimm> <4AF46B90.8010905@sgi.com>
Date: Sat, 7 Nov 2009 12:43:39 +0100
Message-ID: <b647ffbd0911070343s1b469a53ja24bbd61310d8d52@mail.gmail.com>
Subject: Re: [ RFC, PATCH - 2/2, v2 ] x86-microcode: refactor microcode output
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/6 Mike Travis <travis@sgi.com>:
>
> [ ... ]
>
>>  }
>>  +static int summarize_cpu_range(cpumask_var_t range, struct cpu_signature
>> *csig)
>
> Should be  'struct cpumask *range'
>
> cpumask_var_t is only to declare a local cpumask variable.  All cpumasks are
> now
> passed by reference (as a pointer).

ok.

>
> With this patch the console still printed for each cpu:
>
> [    2.131142] mce: CPU supports 22 MCE banks
> [    2.131177]  ssCC PCss ssPP ssss ssss ss
> [    2.211971] mce: CPU supports 22 MCE banks
> [    2.212005]  ssCC PCss ssPP ssss ssss ss
> ...

hmm, have you included the right log? All these messages seem to be
MCE-related, not microcode...



-- Dmitry
