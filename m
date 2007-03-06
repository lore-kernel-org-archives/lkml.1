Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXCFVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXCFVLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXCFVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:11:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXCFVLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:11:54 -0500
Date: Tue, 6 Mar 2007 22:11:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306211105.GD26348@elte.hu>
References: <45ED82D9.6050204@codemonkey.ws> <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu> <45EDD6F1.7080100@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDD6F1.7080100@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> If you're seriously talking about an ABI, [...]

HELLO, this isnt a hypothetical!! The moment there's a xen_paravirt_ops, 
Linux has DE FACTO committed itself to the Xen ABI: whatever 
functionality the hypercall_page call table plus the int $0x82 interface 
offers.

THE MOMENT any of that goes upstream and ships in a distro it's going to 
be there forever! Try to change paravirt_ops or any core bit of Linux so 
that this ABI cannot be sanely supported: 'fix it, you broke Xen!'. It 
wont matter that paravirt_ops is 'internal' to Linux.

so trying to argue as if there was no ABI imposed on Linux by hiding the 
Xen ABI behind paravirt_ops, and whistling into the air as if nothing 
happened is misguided at best.

	Ingo
