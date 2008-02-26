Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbYBZRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbYBZRck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763216AbYBZRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:32:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:7886 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762955AbYBZRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Do/pGDjtuYGgKpBl/+BDYb1etil3+zzeupFubYobRTGcq9QeluFgpCxkaAvocVcYIcxxuVteVMNv9lUW7Ox4eJLsK6pzadICW2POtFoGJ9bBI8rGIE/WvP9TAUOkEZFLieKvH+Gkr9EoAemxORJkpUEXQdFydDQF4wqEWidstEQ=
Message-ID: <6101e8c40802260932p3b01309g4f300a988669b689@mail.gmail.com>
Date: Tue, 26 Feb 2008 18:32:23 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux v2.6.22.20-op1-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kurt Garloff" <garloff@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Michael Hennerich" <Michael.Hennerich@analog.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux v2.6.22.20-op1-rc1
"stable" review patch

what is this tree?
it is my long term supported kernel, when i have time for it, i
backported the most important fixes.

http://repo.or.cz/w/linux-2.6.22.y-op.git rc

--
Makefile | 2 +-
arch/x86_64/mm/pageattr.c | 2 +-
include/linux/page-flags.h | 4 ++--
kernel/irq/chip.c | 20 +++++++++++++++++++-
mm/vmscan.c | 41 +++++++++++++++++++++++++++++++++++++++++
5 files changed, 64 insertions(+), 5 deletions(-)
--
David Howells (1):
 MM: Fix macro argument substitution in PageHead() and PageTail()

Ingo Molnar (1):
 x86_64: CPA, fix cache attribute inconsistency bug, v2.6.22 backport

Kurt Garloff (1):
 make (low) swappiness safer to use

Oliver Pinter (1):
linux v2.6.22.20-op1-rc1

Thomas Gleixner (1):
 genirq: do not leave interupts enabled on free_irq


--
Thanks,
Oliver
