Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYABWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYABWcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYABWcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:32:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYABWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:32:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=C/C35OF/+lFTGXy0m5x3YUEdr6J8pDLyojJ9FaVw1kaxicYjZ9KhOgA7Q49QGDCaL
	MxkTbamHK2LyFnqvBo1tA==
Message-ID: <3f1a065b0801021432k138e52fes3578d3d8d8cfcda5@mail.gmail.com>
Date: Wed, 2 Jan 2008 14:32:35 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
In-Reply-To: <20080102215433.GB13784@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
	 <20071227233419.d1adf3f3.akpm@linux-foundation.org>
	 <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
	 <p731w9410yc.fsf@bingen.suse.de>
	 <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
	 <20080102200039.GA13784@one.firstfloor.org>
	 <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com>
	 <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com>
	 <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
	 <20080102215433.GB13784@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 1:54 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Thanks.  My code doesn't support these CPUs because their northbridge
> > IDs are not 0x1203.
>
> Sure, but do they have the crippling erratum too?

We don't seem to have erratum documentation on this chip, so I can't
confirm one way or another.  In any event, I have no way to test this
CPU.  I think it's a small sacrifice to assume that it doesn't work.
Someone could always add support later.

>
> -Andi
>



-- 
Russell Leidich
