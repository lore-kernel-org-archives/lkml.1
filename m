Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXJOTpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXJOTpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXJOTp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:45:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:5682 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXJOTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aYfZqmPpVRgO42nNCUAgNdcxHWU0Kc+jMt6ETP2XV1nwvW9nUmtJpmyquhdGrqqyKrM/wAeLnAYRRN3c2sPyXTS/EvFoGh6iiwKg1VniYZOivYTmVDF8S6OW22x270sQeqX6Pt0ejtFpGktQSOc0oson1k7eD/sw7QeA510U88o=
Message-ID: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
Date: Mon, 15 Oct 2007 12:45:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Subject: git/cscope with x86 merge
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

after the merge:
1. git
git log -p arch/x86/kernel/io_apic_64.c
only can show the log from the merge..., and can not get log before
merge for x86_64/kernel/io_apic.c
Any git update for that?

2. cscope
on x86_64, it is good to see file in arch/x86/pci/*
but will show other _32.c too.
So is it possible to change find-sources to make filter out _32.* and
mach-* dirs?

YH
