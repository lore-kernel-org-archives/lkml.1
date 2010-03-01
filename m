Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0CARQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:16:29 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57917 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CARQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aM5ng0uPQHi/OevYXA7I3AAkO5HhuJj0UrtfQGkQV1JfPhqPG3sRb9zlLEI/bEiC7f
         DbfLnbwsNBXL93zxXOkFRsJrAOLa8lR9uFFOrMC8vdbg/OR7PDPtQAbm34TdebvYoOdS
         aWddW3FFxm4vKsvpx81A0QqcdR25TD8Z3t92c=
MIME-Version: 1.0
In-Reply-To: <4B8B6E43.9030305@zytor.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
	 <4B845AEE.5080604@zytor.com>
	 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
	 <20100226101423.GA25641@elte.hu>
	 <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com>
	 <ff13bc9a1002260323k6b3f38ah4f0505e401dcf77d@mail.gmail.com>
	 <4B8B6E43.9030305@zytor.com>
Date: Mon, 1 Mar 2010 18:16:25 +0100
X-Google-Sender-Auth: 1134ad3439369176
Message-ID: <ff13bc9a1003010916j860b1bbueebf8e5b21e100ad@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, and with the test turned on, the kernel crashes immediately on boot
> on x86-64.
>
> Some minor investigation reveals the following:
>
> lib/atomic64.c has the wrong return value for atomic64_add_unless().
> With "wrong" I mean it is the opposite sense compared to
> atomic_add_unless(), not just on x86 but on all architectures.
>
> Accordingly, I have to conclude that lib/atomic64.c is buggy, and that
> since your test matches that bug, I will have to conclude that your
> x86-32 implementation is also buggy.  Thus, please send patches to fix
> your test and your 32-bit implementations (and preferrably
> lib/atomic64.c too, but I can do that just fine.)

You are right: sent a patchset to fix it.
