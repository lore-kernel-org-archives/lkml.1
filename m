Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYFKL2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYFKL2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYFKL2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:28:44 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35430 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbYFKL2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:28:43 -0400
Date: Wed, 11 Jun 2008 13:28:38 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tim Bird <tim.bird@am.sony.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] add diffconfig utility
In-Reply-To: <484F1B8F.9000804@am.sony.com>
Message-ID: <Pine.LNX.4.64.0806111328150.13310@vixen.sonytel.be>
References: <484ED902.9040000@am.sony.com> <20080610212158.GB23855@uranus.ravnborg.org>
 <484F1B8F.9000804@am.sony.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-2076112589-1213183718=:13310"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-2076112589-1213183718=:13310
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 10 Jun 2008, Tim Bird wrote:
> +merge_style = 0
> +if "-m" in sys.argv:
> +    merge_style = 1
> +    sys.argv.remove("-m")
> +
> +if "-h" in sys.argv or len(sys.argv) < 3:
                                        ^^^
No checking for excess arguments?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-2076112589-1213183718=:13310--
