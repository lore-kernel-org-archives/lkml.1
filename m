Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYJPIbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYJPIbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYJPIa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:30:56 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47887 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753375AbYJPIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:30:55 -0400
Date: Thu, 16 Oct 2008 10:30:52 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Miller <davem@davemloft.net>
cc: hpa@zytor.com, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <20081013.223811.174710738.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
References: <48F3F014.3050406@zytor.com> <1223948488.8157.309.camel@pasglop>
 <48F409E9.3030501@zytor.com> <20081013.223811.174710738.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-10248566-1224145852=:9022"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-10248566-1224145852=:9022
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 13 Oct 2008, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Mon, 13 Oct 2008 19:54:33 -0700
> 
> > I pointed out that we should use the flags to determine formatting
> > options, e.g. I/O space is only 16 bits on x86.
> 
> It's 64-bit on sparc64 :-)
> 
> There's also the bit where we use a 32-bit resource_t on sparc32
> but encode the top 4-bits of the 36 bit physical I/O address in
> the resource flags member.

So wouldn't it be better to switch those sparc32 configs to a 64-bit
resource_t? I think all other platforms with 36-bit physical addresses went
that way.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-10248566-1224145852=:9022--
