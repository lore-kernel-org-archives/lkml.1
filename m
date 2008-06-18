Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYFRXcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYFRXcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYFRXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:31:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:33419 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbYFRXbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:31:44 -0400
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <b020e42384197b824320.1213615800@localhost>
References: <b020e42384197b824320.1213615800@localhost>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 09:23:23 +1000
Message-Id: <1213831403.8011.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 04:30 -0700, Jeremy Fitzhardinge wrote:
> 
> The only current user of this interface is mprotect

Do you plan to use it with fork ultimately ?

Ben.


