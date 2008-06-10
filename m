Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYFJCrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYFJCrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYFJCrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:47:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61084 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753014AbYFJCrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:47:03 -0400
Date: Tue, 10 Jun 2008 03:46:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
Message-ID: <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-7-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-8-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-9-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-10-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-11-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-12-git-send-email-gcosta@redhat.com> 
 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>  <484D8813.4040807@redhat.com>
  <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>
 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Maciej W. Rozycki wrote:

> > we need clear_IO_APIC before enable setup error vector, in case there
> > is wrong setting in ioapic by BIOS...
> 
>  Fair enough, although it is still interesting why it would only trigger 
> in the 64-bit mode and why shouldn't the BIOS be fixed instead.

 Then again -- what if X86_LOCAL_APIC is set, but X86_IO_APIC is not?

  Maciej
