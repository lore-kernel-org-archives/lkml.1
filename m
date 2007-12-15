Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbXLOHlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbXLOHlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXLOHlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:41:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:13985 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXLOHk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GoMm4w7grtUiKHU3qfHsVxM3pv/WgjwbtSgEwkOpki8mX0pOw0llqGsk8g5S99JzjPZgHvgKrbjev7yuTqJIfHvcX6fRseY5Cg024b9e0fu//pC15rX6/jo6Ap9b0omiuplT2qLmExxC4EFsjNQjzCEmUQhg/FFXbw33rXodENo=
Subject: Re: [PATCH] x86: Use helper in kprobes{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071215073644.GC12110@elte.hu>
References: <1197680107.898.81.camel@brick> <20071215073644.GC12110@elte.hu>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 23:40:57 -0800
Message-Id: <1197704457.898.84.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-15 at 08:36 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > x86: Use helper in kprobes{32|64}.c
> 
> thanks, i've applied your kprobes pre-unification patches to x86.git. 
> 
> While we are at it, it might be nice to reduce the numbers of checkpatch 
> warnings:
> 
>  $ scripts/checkpatch.pl --file arch/x86/kernel/kprobes*.c  | grep total
>  total: 10 errors, 9 warnings, 959 lines checked
>  total: 10 errors, 8 warnings, 923 lines checked
> 
> to 0/0 ? :-) (but that can happen after the unification too)
> 

That was my plan...you'll notice I already cut ~200 from each file
though, so the lion's share is done.  I'll have the final few in the
series shortly.

Harvey

