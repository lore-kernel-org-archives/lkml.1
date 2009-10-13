Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZJMPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZJMPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbZJMPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:35:06 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62982 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760290AbZJMPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MfzXjoClPAAFcV67hrb31afHxkTOIl82tKNA9Qe0HYjeTvUJStiqi8oJh/rcb1XhNT
         X9NlRov4uBCoMgJlYr+m6W0dLhsPdfFa7vMH80r1zr2AWhGRfLA29adDN7A7RXpFRPjA
         5vrGk13+WuIxwXLsoqTJxQgQ3siiVARN6KRAQ=
MIME-Version: 1.0
In-Reply-To: <20091013154943.1e1d3c3f@lxorguk.ukuu.org.uk>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
	 <20091012213229.11898c12@infradead.org>
	 <20091013060312.GA3215@elte.hu>
	 <817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
	 <20091013070722.6e27b25e@infradead.org>
	 <20091013141527.GA7053@elte.hu>
	 <20091013072907.1daeba73@infradead.org>
	 <20091013154943.1e1d3c3f@lxorguk.ukuu.org.uk>
Date: Tue, 13 Oct 2009 11:34:26 -0400
Message-ID: <817ecb6f0910130834y1b039515q245d586e5e281fc6@mail.gmail.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'd be surprised if anything ever did; this is the *kernel* mapping of
>> the first megabyte, not some userspace mapping....
>
> APM, BIOS32, EDD, PnPBIOS ..
>
> However except for APM (which isn't generally needed on NX capable
> devices or found on them) none of them are usually on critical paths
> because EDD is just grovelling around sort of stuff, and BIOS32 isn't
> generally used by the kernel anyway so could probably cope with flipping
> the permissions on the low 1 MB each call.

Actually, I have posted a patch to fix RW+X problem with BIOS32 some
time ago. See my submission to LKML (and subsequent discussion) on Jul
19 2009 "[PATCH] x86: Reducing footprint of BIOS32 service mappings".

Nevertheless, that 1MB area is on my "to do" list, and I will be
patching it sooner or later (assuming I get my patches tested well
enough to get them accepted).
