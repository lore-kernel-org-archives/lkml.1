Return-Path: <linux-kernel-owner+w=401wt.eu-S936654AbXHGVsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936654AbXHGVsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965933AbXHGV0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:26:46 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.83]:38151 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965917AbXHGV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:26:44 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GPL / MPL license issues.
In-Reply-To: <20070807202758.GA1937@redhat.com> (Dave Jones's message of "Tue\,
	7 Aug 2007 16\:27\:58 -0400")
References: <20070807202758.GA1937@redhat.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 07 Aug 2007 17:26:35 -0400
Message-ID: <877io711f8.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> There are a number of files in the kernel that have in their
> headers a notice that the file is under the Mozilla Public License,
> which alone, is incompatible with the GPL.

> This itself is fine, as long as the resulting code claims
> to be Dual MPL/GPL, however there are a few cases where this
> doesn't seem to be happening.

All of the files that you cite include a notice that they are licensed
under the GPLv2, in addition to the MPL.  There is no reason that
MODULE_LICENSE needs to indicate that some portions of code may also be
available under an alternative license.  Furthermore, for some modules
that contain both code licensed under the GPLv2 exclusively, and code
dual-licensed under both the GPLv2 and the MPL, it would be incorrect to
state that the combined work is dual-licensed under the GPLv2 and the
MPL.

As far as providing a convenience to users, I can't see why anyone would
really care that a particular module includes some code that may be
licensed under the MPL as well.  Anyone actually looking through the
kernel for code to incorporate into an MPL project would surely read the
copyright headers at the top of the source files, rather than try to use
the MODULE_LICENSE notes.

[snip]

-- 
Jeremy Maitin-Shepard
