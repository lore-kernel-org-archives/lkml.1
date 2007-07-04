Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbXGDLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbXGDLZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759360AbXGDLZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:25:29 -0400
Received: from ozlabs.org ([203.10.76.45]:42670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbXGDLZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:25:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.33636.66185.902453@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 21:24:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041310.11336.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707041233.18199.rjw@sisk.pl>
	<18059.31464.183382.358931@cargo.ozlabs.ibm.com>
	<200707041310.11336.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> BTW, does your platform's suspend work on SMP systems?

Yes; currently we require userspace to offline all cpus other than the
boot cpu before initiating the suspend.

The main difficulty is actually that SMP powermacs that can suspend
tend to have video cards that get powered off in suspend.  We know how
to re-initialize one (the Radeon RV100 QW) but not others.  That's an
orthogonal issue to the issues we have been discussing, though.

Paul.
