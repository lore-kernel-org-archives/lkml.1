Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZGEL7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZGEL7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZGEL7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:59:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62000 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZGEL7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cer52B/5hm3NgUXAqPHDwZ6Vf2S7yufAGwwnp8vxfUtGG3gwpC4MoWAQaVxD9qrqyY
         KfYk51pL6NA0XnI91y6uCKh5jMwbODRV6Y0VrcU+TOrxoH/kOKIiouWcO9264TAmO6gR
         z8/spEyy6jka9y61Z/mS1yruanYeQ+yc2Z3xk=
MIME-Version: 1.0
In-Reply-To: <1246773777.2325.113.camel@jaswinder.satnam>
References: <20090703164225.GA21447@elte.hu>
	 <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
	 <4A4FC5D0.6090000@kernel.org> <20090705002709.GA28424@elte.hu>
	 <1246773777.2325.113.camel@jaswinder.satnam>
Date: Sun, 5 Jul 2009 14:59:48 +0300
X-Google-Sender-Auth: f11c9666b903508b
Message-ID: <84144f020907050459x6a9a11fmf8f3050f085c8d85@mail.gmail.com>
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Sun, Jul 5, 2009 at 9:02 AM, Jaswinder Singh
Rajput<jaswinder@kernel.org> wrote:
> On Sun, 2009-07-05 at 02:27 +0200, Ingo Molnar wrote:
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> > >  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
>> > > +
>> > >  static int __initdata debug_print;
>> > > +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
>> > > +
>> > > +
>> >
>> > two blank lines?
>>
>> ah, yes - i moved them around.
>>
>> > > +#define BIOS_BUG_MSG KERN_WARNING \
>> > > + "WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
>> >
>> > No user for this
>>
>> yeah. Mind sending a patch for these? (and any other things you
>> might notice)
>>
>
> But why you did this stupidity.
>
> I clearly specified that these are trivial clean-ups, if you found any
> issue in the patch you should ping me. Instead of adding crap from your
> side.

What's with the attitude? It's perfectly okay for a commiter to change
the patch as long as it's mentioned in the changelog. And that's
usually much faster to do that for minor issues rather than ping the
original submitter and wait for a resend.

                       Pekka
