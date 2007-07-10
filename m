Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbXGJUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbXGJUsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbXGJUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:48:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbXGJUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:48:12 -0400
Message-ID: <4693EFBF.4070605@zytor.com>
Date: Tue, 10 Jul 2007 13:44:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [x86 setup 16/33] String-handling functions for the new x86 setup
 code.
References: <11840359321823-git-send-email-hpa@zytor.com> <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr> <4693D183.9060604@zytor.com> <298A54C9-B331-4AB9-98B3-5C815B04381E@kernel.crashing.org>
In-Reply-To: <298A54C9-B331-4AB9-98B3-5C815B04381E@kernel.crashing.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> Nope.  The builtins not only vary between gcc versions, but they also
>> have a nasty tendency to generate calls to library functions, sometimes
>> libgcc functions.  Hence -ffreestanding.
> 
> -ffreestanding will still generate calls to libgcc functions.
> -ffreestanding doesn't disable _all_ of the C library, either.
> 

No, it doesn't, but it does inhibit builtin functions, and so provides a
bit more ABI stability.

	-hpa
