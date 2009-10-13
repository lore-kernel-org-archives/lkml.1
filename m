Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbZJMOtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbZJMOtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbZJMOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:49:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45341 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759579AbZJMOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:49:47 -0400
Date: Tue, 13 Oct 2009 15:49:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Message-ID: <20091013154943.1e1d3c3f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013072907.1daeba73@infradead.org>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
	<20091012213229.11898c12@infradead.org>
	<20091013060312.GA3215@elte.hu>
	<817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
	<20091013070722.6e27b25e@infradead.org>
	<20091013141527.GA7053@elte.hu>
	<20091013072907.1daeba73@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd be surprised if anything ever did; this is the *kernel* mapping of
> the first megabyte, not some userspace mapping....

APM, BIOS32, EDD, PnPBIOS ..

However except for APM (which isn't generally needed on NX capable
devices or found on them) none of them are usually on critical paths
because EDD is just grovelling around sort of stuff, and BIOS32 isn't
generally used by the kernel anyway so could probably cope with flipping
the permissions on the low 1 MB each call.
