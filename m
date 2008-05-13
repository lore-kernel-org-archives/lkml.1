Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYEMRf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYEMRf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYEMRfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:35:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:25748 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYEMRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CVteqPJv2GkUI8Ar+4WvAhVl3r9/BuOqsFgCeGeCccWN++OvvjwdfWf2rTijmgXDO4HJAK9KiX2SHksejomQoKx2H4t4S+Bm+jOPCuAQ7+18iypzWnu4tiDiv1Nzx1H+ctyPinf7eld1KntPSAHL5xKA8sAzpgpOp3jtcnuPhM8=
Message-ID: <86802c440805131035t18955103w94cd8fefbdabdf57@mail.gmail.com>
Date: Tue, 13 May 2008 10:35:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make e820.c to have common functions
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080513130539.GL14973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <20080513130539.GL14973@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 6:05 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > remove the duplicated copy of these functions.
>
>  applied, thanks. What a low-key commit message for the first step such a
>  much-needed unification! :-)
>
>  any thoughts (or patches) about how to attack the rest of e820_32/64.c?

reserve_early related to 32 bit. but could cause some regression to subarch

but it seems hpa is doing sth about e820 related too?

YH
