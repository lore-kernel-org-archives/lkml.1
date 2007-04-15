Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXDOKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXDOKja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXDOKja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:39:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:19300 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXDOKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iXr87lbSSWcfMHwpivtXajAiF2X404xJB4etKI9OqEC6PbEWj0RNgeMNlpuR3Vxty1aoheHzc2go9oXMXGsZLZvUddUyGT40nMunG7jPyTIXwNdqcrw6ySpVjcMxvJfhPAZgoHoI1e6h8fJPw3cjlhWXq1Fc5KmUFoW4zE6g7pY=
Message-ID: <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
Date: Sun, 15 Apr 2007 13:39:27 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "hui Bill Huey" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Cc: "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       "ck list" <ck@vds.kolivas.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070415095146.GA30327@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu>
	 <200704151327.13589.kernel@kolivas.org>
	 <20070415051645.GA28438@gnuppy.monkey.org>
	 <20070415084447.GC24886@elte.hu>
	 <20070415095146.GA30327@gnuppy.monkey.org>
X-Google-Sender-Auth: e81f7d72a0e210e4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/07, hui Bill Huey <billh@gnuppy.monkey.org> wrote:
> The perception here is that there is that there is this expectation that
> sections of the Linux kernel are intentionally "churn squated" to prevent
> any other ideas from creeping in other than of the owner of that subsytem

Strangely enough, my perception is that Ingo is simply trying to
address the issues Mike's testing discovered in RDSL and SD. It's not
surprising Ingo made it a separate patch set as Con has repeatedly
stated that the "problems" are in fact by design and won't be fixed.
