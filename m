Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYDJRdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYDJRdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYDJRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:32:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:4426 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYDJRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UVLR/F0OYPHU7NouDKJNrZ4bT0ikhl3YKnBywWO2EpIsRHBwtBARNredWpXrk8KdgPmvtxL4x2tFvcbFnVoLxkqZItAIFaNfQalG6SdAWhfe1tV8Gyqu9c8FGQHo6gtNVvsTVkDRMUnjHoAeRidjgdVIaNqHJlM4+kWxKbgw4Sk=
Message-ID: <de8d50360804101032p6c82ed33i686c13f0bfc70e8a@mail.gmail.com>
Date: Thu, 10 Apr 2008 10:32:53 -0700
From: "Andrew Pinski" <pinskia@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pop previous section in alternative.c
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Andy Whitcroft" <apw@shadowen.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>, akpm@linux-foundation.org,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Jan Beulich" <jbeulich@novell.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <47FE493C.2010709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
	 <20080410094637.GW17915@shadowen.org>
	 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
	 <20080410144114.GH10019@one.firstfloor.org>
	 <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
	 <20080410150544.GI10019@one.firstfloor.org>
	 <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>
	 <47FE3B24.4020301@zytor.com>
	 <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com>
	 <47FE493C.2010709@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:07 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>  Of course, The Right Thing[TM] would be for gcc to emit .pushsection ...
> .popsection around #APP ... #NO_APP.

Why??  GCC assumes that people don't do crazy things in their
inline-asm and the source did in this case.

Thanks,
Andrew Pinski
