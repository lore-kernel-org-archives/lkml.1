Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZA2W6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZA2W6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA2W6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:58:33 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:63648 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZA2W6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qks5JkjKAySD06sxR3i5cltGSr8Np/50MErizC6DaaZ3ELQdZ4appKs6wdt19Ch0jm
         yrXxz9K7cswCP4z4jXy8dHpC9XgApjsng0WmZDRVwSG4Z2oISJv7OeqXPWl+PIBKiG8S
         GLYGpe19P6ZbIh9OdoMS9KHTTRqxosdh/lBE8=
MIME-Version: 1.0
In-Reply-To: <20090129221402.GA1984@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
	 <87vdryw6ql.fsf@basil.nowhere.org>
	 <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com>
	 <20090129221402.GA1984@elte.hu>
Date: Thu, 29 Jan 2009 14:58:28 -0800
X-Google-Sender-Auth: c0d6ff0ef9f5ac0e
Message-ID: <eada2a070901291458m24249390xc0df8c11a2d2fd15@mail.gmail.com>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old 
	subarchitecture code
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 2:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> At this point there's no technical need to kill it - it's a zero-overhead
> thing tucked away into a single .c module in arch/x86/kernel/numaq_32.c. I
> even consolidated most of its headers in that file, to reduce its cross
> section.

Wish we'd have piped up earlier to save you a bit of work.

> So two days ago it might have made some sense to rip out this code - now
> there's no pressing need really. We can remove it in a few years once the
> last beep has been received from those platforms. The numaq code is now
> quite similar to an old driver in drivers/* - there's no real downside
> from having it around.

We can make the NUMAQ's beep still, if not boot.  :)

Reality is they're just not worth the effort any more and there's no
sign of anybody else having them.  Assuming your code goes in for
2.6.30 it'll be easy to drop NUMAQ support.  Even if there's not much
downside there's also not much reason to leave it in but marked
deprecated/broken.



Tim
