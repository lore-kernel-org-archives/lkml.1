Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbXKBRzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbXKBRzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXKBRzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:55:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:24930 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbXKBRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CUxB/GKb95fE2R6gwBc6ePPZGBoDaI5o6ACd2ICKQQa2x79EQLU5ihnx14TCggv0FtgPsEGIXf0LX8Ff1nS2iR2IwSHdKdaomxJkgf1ijv8gksET/KS922wMu/zg16iaIBRLGXyMbDOF7c1J4e32UeCzMsSskOnS9tg8JGmn/DE=
Message-ID: <86802c440711021055s134054e0w39043fcb33a26939@mail.gmail.com>
Date: Fri, 2 Nov 2007 10:55:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: nmi_watchdog on x86_64
Cc: "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0710172220510.24155@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
	 <alpine.LFD.0.9999.0710172220510.24155@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 17, 2007 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>
>
> On Mon, 15 Oct 2007, Yinghai Lu wrote:
>
> > just found my on hand ck804, and mcp55 based AMD servers:
> > nmi_watchdog=1 doesn't work
> > but nmi_watchdog=2 does work
> >
> > =1, it say: IOAPIC 8259A virtual wire mode...
> >
> > Did nmi_watchdog=1 work on any other amd64 platform?
>
> I think I used it, but I don't remember when. Will try tomorrow.

any update?

non amd64 based system works with that. (amd8111, ck804, mcp55)
or 8259 virtual wired mode to local apic LVT0 never work?

YH
