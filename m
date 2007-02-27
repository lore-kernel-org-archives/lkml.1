Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXB0TYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXB0TYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXB0TYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:24:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44992 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXB0TYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:24:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 0/3] Basic msi bug fixes..
Date: Tue, 27 Feb 2007 12:24:17 -0700
Message-ID: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While looking at some other irq issues I realized that the current msi code
has a serious issue in that we don't have support for masking msi interrupts
on all variations of the msi capabilities.

Closing that hole is simple, but it requires the msi enable/disable
logic to be sorted out. Which is a little more complicated...

These are moderately simples fixes so the should be safe for 2.6.21.

Eric
