Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXGEAXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXGEAXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbXGEAXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:23:43 -0400
Received: from ozlabs.org ([203.10.76.45]:46601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbXGEAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:23:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.14341.341604.666867@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:15:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041630.30048.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707041310.11336.rjw@sisk.pl>
	<18059.33636.66185.902453@cargo.ozlabs.ibm.com>
	<200707041630.30048.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> This is incompatible with the code in kernel/power/main.c, since we only
> disable the nonboot CPUs after devices have been suspended.  Do you think that
> your framework can be modified to work without disabling the nonboot CPUs
> by the user space?

Sure.  It was a "if it can be done in userspace, do it in userspace"
kind of decision, but I'm not wedded to it.

I actually do want to converge to using the generic suspend-to-ram
code on powerbooks.  I just want to avoid causing regressions for
powerbook users, including myself. :)

Paul.
