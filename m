Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYI2R4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYI2R4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYI2R4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:56:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:40697 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYI2R4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BZFVYMPq6E82oqSEZm3aCDVLiXvIuXQCwDFnL+2wEHIfXGQKIwurECCNRmLHjWxgoP
         2uppxJqZ3UFfc1zeCTBR7DSCR8H/Tumuq0vJjSytVdH1RgB+pI436I8slc1qdbD/oHiH
         2Dxpr+3ZBl//nJGZblwbI4iTvPLf3VEeFiI3A=
Message-ID: <86802c440809291056m7369062ft6b16d17299ca5701@mail.gmail.com>
Date: Mon, 29 Sep 2008 10:56:29 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Krzysztof Helt" <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] x86: enable CPUID on Cyrix cpus with CPUID disabled
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       sfr@canb.auug.org.au, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080929192407.1c31fe90.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080929192407.1c31fe90.krzysztof.h1@poczta.fm>
X-Google-Sender-Auth: 9f763776a15f2a0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:24 AM, Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> The macros setCx86_old() and getCx86_old() do not
> work as a comment says in the processor-cyrix.h.
>
> Use working inline functions instead to enable
> the CPUID instriction on Cyrix cpus.
>
> Tested on IBM 6x86MX cpu with disabled the
> CPUID instruction.
>
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>
> This patch is against the linux-next tree (20080819)
> as it contains the following patch:
>
> x86, cyrix: debug
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=026e2c05ef58ef413e2d52696f125d5ea1aa8bce
>
> The linux-2.6-tip tree has not the Ingo's patch so it
> does not require my patch.
>
> I am confused. Is the x86 detection code for Cyrix
> cpus is right in the linux-next or in the linux-2.6-tip?
> Should I prepare patches against the linux-2.6-tip
> or linux-next?

linux-2.6-tip.

YH
