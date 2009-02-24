Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbZBXXgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbZBXXgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZBXXga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:36:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbZBXXg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:36:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: kyle@infradead.org
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, kyle@redhat.com,
       aoliva@redhat.com
Subject: Re: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with
	gcc-4.4
In-Reply-To: Kyle McMartin's message of  Tuesday, 24 February 2009 01:51:12 -0500 <20090224065112.GA6690@bombadil.infradead.org>
References: <20090224065112.GA6690@bombadil.infradead.org>
X-Zippy-Says: Uh-oh -- WHY am I suddenly thinking of a VENERABLE religious leader
    frolicking on a FORT LAUDERDALE weekend?
Message-Id: <20090224233613.B97B9FC380@magilla.sf.frob.com>
Date: Tue, 24 Feb 2009 15:36:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is right though the log entry and comment are perhaps misleading.
The effect of the patch is to restore the compiler behavior to what it was
before.  What it was before includes cases of producing .eh_frame and cases
of not producing it.  The default behavior of a gcc-4.4 that was built
against new enough binutils has diverged, so that some situations that
before produced no .eh_frame now do produce one.  -fno-dwarf2-cfi-asm
tells gcc to behave like it did before (which is also how 4.4 behaves when
built against an old enough binutils).


Thanks,
Roland
