Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXGJVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXGJVO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbXGJVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:14:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:59345 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759807AbXGJVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:14:51 -0400
In-Reply-To: <4693EFBF.4070605@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr> <4693D183.9060604@zytor.com> <298A54C9-B331-4AB9-98B3-5C815B04381E@kernel.crashing.org> <4693EFBF.4070605@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C65610C3-64A5-476D-8371-1338FA8F7D0E@kernel.crashing.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 16/33] String-handling functions for the new x86 setup code.
Date: Tue, 10 Jul 2007 23:14:38 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Nope.  The builtins not only vary between gcc versions, but they  
>>> also
>>> have a nasty tendency to generate calls to library functions,  
>>> sometimes
>>> libgcc functions.  Hence -ffreestanding.
>>
>> -ffreestanding will still generate calls to libgcc functions.
>> -ffreestanding doesn't disable _all_ of the C library, either.
>
> No, it doesn't, but it does inhibit builtin functions, and so  
> provides a
> bit more ABI stability.

Yes, Linux should definitely be compiled with -ffreestanding,
it isn't a hosted application after all ;-)


Segher

