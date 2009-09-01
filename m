Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZIANzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZIANzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZIANzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:55:22 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37203 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbZIANzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:55:22 -0400
To: venki kaps <venkiece2005@gmail.com>
Cc: Nicolas Pitre <nico@cam.org>,
       "sagar.abhishek\@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto\@us.ibm.com" <jkenisto@us.ibm.com>,
       "rmk+kernel\@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna\@in.ibm.com" <prasanna@in.ibm.com>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
	<alpine.LFD.2.00.0908251333410.6044@xanadu.home>
	<6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com>
	<6d53329e0908310311v55ef3909na0cbec756e63ccab@mail.gmail.com>
	<6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 01 Sep 2009 14:54:54 +0100
In-Reply-To: <6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com> (venki kaps's message of "Tue\, 1 Sep 2009 12\:25\:37 +0530")
Message-ID: <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 13:54:56.0981 (UTC) FILETIME=[CA292850:01CA2B0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venki kaps <venkiece2005@gmail.com> wrote:
> I have found the exact problem with respect to ARM jprobes.
>
> The problem with configure i.e, CONFIG_ARM_UNWIND = y; is enabled.

I haven't followed the kprobes implementation for ARM but does it make
any assumptions about the existence of a frame pointer on the stack?
Enabling stack unwinding automatically disables the framepointer.

-- 
Catalin
