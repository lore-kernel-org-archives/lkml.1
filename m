Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYJaVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYJaVWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYJaVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:22:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:16629 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJaVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JMPOtNVDz7hPOQhs7UKTyKAaBIicO/bwSYWL77EC9vXcO2uDxtZ/BDmgXwfBl9xCi3
         4XtIAD5sy3T3OZxUMBUWftVd/TGfOcIP4C2c8lY6jlWsGR5AoDYeKCxyQUOy5tb6O4fp
         n6KhqbnTwSNhhW4EDdWvlGFxI81eBvysBDUxs=
Message-ID: <86802c440810311422w79d0e697k246cb5ca76bf91b5@mail.gmail.com>
Date: Fri, 31 Oct 2008 14:22:36 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: nmi - document lapic and ioapic parameters
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Aristeu Rozanski" <aris@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20081031192358.GC20803@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031192358.GC20803@localhost>
X-Google-Sender-Auth: f244a3dde22842df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 12:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
> On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2
>
> Index: linux-2.6.git/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/kernel-parameters.txt      2008-10-27 21:35:08.000000000 +0300
> +++ linux-2.6.git/Documentation/kernel-parameters.txt   2008-10-31 22:21:59.000000000 +0300
> @@ -1404,6 +1404,14 @@ and is between 256 and 4096 characters.
>                        Format: [state][,regs][,debounce][,die]
>
>        nmi_watchdog=   [KNL,BUGS=X86-32] Debugging features for SMP kernels
> +                       Format: [panic,][num]
> +                       Valid num: 0,1,2
> +                       0 - turn nmi_watchdog off
> +                       1 - use IO-APIC
> +                       2 - use local APIC
> +                       Instead of 1 and 2 it is possible to use the following
> +                       symbolic names: lapic and ioapic
> +                       Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
>
>        no387           [BUGS=X86-32] Tells the kernel to use the 387 maths
>                        emulation library even if a 387 maths coprocessor
> --

please update

Documentation/x86/x86_64/boot-options.txt

too.

YH
