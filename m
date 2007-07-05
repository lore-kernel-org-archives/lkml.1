Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXGEArI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXGEArI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXGEAqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:46:55 -0400
Received: from ozlabs.org ([203.10.76.45]:51199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbXGEAqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:46:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.16250.191996.324672@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:46:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <20070705000301.GE2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031454.42078.nigel@nigel.suspend2.net>
	<1183441706.10386.73.camel@localhost.localdomain>
	<20070705000301.GE2719@elf.ucw.cz>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek writes:

> How well does it work on SMP PPC?

Just fine, on those machines where we know how to reinitialize the
video card.  We currently require userspace to offline all except the
boot cpu before suspending, but that could be moved into the kernel.
I have no particular attachment to that way of doing it; it was just a
"don't do things in the kernel that can be reasonably be done in
userspace" kind of thing.

Paul.
