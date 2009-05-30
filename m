Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZE3Ilc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZE3Ilc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZE3IlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:41:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbZE3IlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:41:23 -0400
Date: Sat, 30 May 2009 01:40:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com, mingo@elte.hu,
       norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-Id: <20090530014007.3c1e22d5.akpm@linux-foundation.org>
In-Reply-To: <20090530081954.GA21954@liondog.tnic>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
	<20090528164720.0af5752b.akpm@linux-foundation.org>
	<20090529103329.GB23530@aftab>
	<20090529130115.a44efaee.akpm@linux-foundation.org>
	<20090530081954.GA21954@liondog.tnic>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 10:19:54 +0200 Borislav Petkov <petkovbb@googlemail.com> wrote:

> Also, I've been thinking about how the old(er)
> toolchain problem can be addressed and one fairly doable thing would be
> if I'd query the gas version in the kernel Makefile and define popcnt
> dependent on it and for older assemblers simply slap in the opcode and
> fixate the operands in an inline assembly so that it works.

We've done that before.  BUG() is one case (for other reasons), I think.

But if we have the code in there which uese the literal opcode, there's
no need to query gas or to add the conditional.

Is popcnt supported on all CPUs?
