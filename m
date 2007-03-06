Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbXCFIUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbXCFIUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXCFIUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:20:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbXCFIUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:20:22 -0500
Date: Tue, 6 Mar 2007 09:19:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Xen & VMI?
Message-ID: <20070306081909.GA9331@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ECC9B6.1060209@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


btw., while we have everyone on the phone and talking ;) Technologically 
it would save us a whole lot of trouble in Linux if 'external' 
hypervisors could standardize around a single ABI - such as VMI. Is 
there any deep reason why Xen couldnt use VMI to talk to Linux? I 
suspect a range of VMI vectors could be set aside for Xen's dom0 (and 
other) APIs that have no current VMI equivalent - if there's broad 
agreement on the current 60+ base VMI vectors that center around basic 
x86 CPU capabilities - which make up the largest portion of our 
paravirtualization complexity. Pipe dream?

there are already 5 major hypervisors we are going to support (in 
alphabetical order):

 - KVM
 - lguest
 - Windows
 - VMWare
 - Xen

the QA matrix is gonna be a _mess_. Okay, lguest and KVM is special 
because both the client and the server side is in the same source code, 
so the ABI [if any] is alot easier to manage. That still leaves another 
three...

	Ingo
