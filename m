Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYBGKYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYBGKYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYBGKYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:24:04 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38342 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753761AbYBGKYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:24:01 -0500
Date: Thu, 7 Feb 2008 11:23:50 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking
In-Reply-To: <20080206134959.GA25689@elte.hu>
Message-ID: <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
 <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-88531015-1202379830=:11914"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-88531015-1202379830=:11914
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 6 Feb 2008, Ingo Molnar wrote:
> @@ -541,6 +541,18 @@ config ELF_CORE
>  	help
>  	  Enable support for generating core dumps. Disabling saves about 4k.
>  
> +config COMPAT_BRK
> +	bool "Disable heap randomization"
> +	default y
> +	help
> +	  Randomizing heap placement makes heap exploits harder, but it
> +	  also breaks ancient binaries (including anything libc5 based).
> +	  This option changes the bootup default to heap randomization
> +	  disabled, and can be overriden runtime by setting
> +	  /proc/sys/kernel/randomize_va_space to 2.
> +
> +	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.

Somehow my belly feeling tells me something is wrong with this description...

Ah, a negative option (Y -> disable).  So Y is always safe.

`non-ancient distros' really means `recent distros', and if you have one,
then _N_ should be a safe choice, too?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-88531015-1202379830=:11914--
