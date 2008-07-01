Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYGASnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYGASnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGASnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49267 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYGASnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:13 -0400
Subject: [PATCH 00/05] x86: Unify TSC code for 32bit and 64bit.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:10 -0700
Message-Id: <1214937790.20191.29.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,

Here is the patchset which merges the tsc code.

I have tried to divide the patchset in terms of merging a functionality
at a time. I have tried to make the individual patches as independent as
possible. From bisectability  point of view each patchset should compile
and run individually as well. 

These patches are based on the current tip/master tree. 
I have tested with around 10 randconfig for each i386 and x86_64.

Please have a look.

Thanks,
Alok


