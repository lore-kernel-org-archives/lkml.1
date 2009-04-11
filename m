Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZDKPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZDKPjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 11:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZDKPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 11:39:29 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56699 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbZDKPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 11:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KzydDC7HTP8BAIdjV+QmUM/Vpx0bjs6yWvgrTbjtjRhzVC4HkVGxaAXJCDe/T3kZwD
         0p+e0Kx7oBZMVNGaslKrBhgvZSqOSA5xsODPa2k5AkHuEPEro3NHltd9ibpq8vtFVTGu
         FUpMBEwjh0gJIgmqwA4P/788oY7FPYzIhU1TM=
MIME-Version: 1.0
In-Reply-To: <20090410160137.2f6261ff.akpm@linux-foundation.org>
References: <1239288723-4240-1-git-send-email-abogani@texware.it>
	 <20090410160137.2f6261ff.akpm@linux-foundation.org>
Date: Sat, 11 Apr 2009 17:39:26 +0200
X-Google-Sender-Auth: 953fce48d224796e
Message-ID: <63a49ef40904110839w53cde9c6k1a261effd1338942@mail.gmail.com>
Subject: Re: [PATCH] tifm: avoid inconsistent lock state
From: Alessio Igor Bogani <abogani@texware.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oakad@yahoo.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir Morton,

2009/4/11 Andrew Morton <akpm@linux-foundation.org>:
[...]
> tifm_7xx1_isr() can legitimately use spin_lock() on that lock, because
> it's running in hard IRQ context and "knows" that tifm_7xx1_isr()
> cannot be reentered on this CPU while it is running.
[...]

Thank you for reply and explanation.

Ciao,
Alessio
