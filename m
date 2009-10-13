Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZJMPr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZJMPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbZJMPr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:47:57 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:34071 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992AbZJMPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OqIFL7gbLWEk4l4pr0FeOz1unbozY1ksm3aMXnAYXSatFYfextdgNsjYRjdxYd4Afj
         i8urLaZItWxWgo/NgC+w973SyXmVkdy+r8gOodcpG0e4GqZfPxd2zUAKxQoAVzf+9ta/
         c7Hc0QFAhk+2r0Wk6T5UyIZ5sgQNglOJjKG04=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910062202590.5950@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
	 <3efb10970910061123k2b6826bci11f0f42509173b26@mail.gmail.com>
	 <alpine.LFD.2.00.0910062122230.5950@localhost.localdomain>
	 <alpine.LFD.2.00.0910062202590.5950@localhost.localdomain>
Date: Tue, 13 Oct 2009 17:46:48 +0200
X-Google-Sender-Auth: 0685228c3b25315f
Message-ID: <3efb10970910130846h2f9d4dbdk755f211fe8d43d4d@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31.2-rt13
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2009/10/6 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 6 Oct 2009, Thomas Gleixner wrote:
>
>> On Tue, 6 Oct 2009, Remy Bohmer wrote:
>> > But I was wondering if you missed this one:
>> > http://patchwork.kernel.org/patch/50044/
>>
>> Yup, slipped through. Queued for the next release.
>
> Correction. I dropped the patch as it is just a sloppy work around.
> Why creating the thread in the first place ? Real fix below.

Well, I noticed a few minutes ago that the sirq-hrtimer is
periodically being scheduled (every 50msec here)
It does not do much, but it still it does something... (no idea what though)

So, is it really right to prevent it from starting up?

Remy
