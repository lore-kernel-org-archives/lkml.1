Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYDIWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYDIWJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYDIWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:09:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYDIWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:09:12 -0400
Date: Wed, 9 Apr 2008 15:08:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Mayer <ajm@sgi.com>
cc: mingo@elte.hu, linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
In-Reply-To: <Pine.SGI.3.96.1080409163241.8706317L-100000@fergus.americas.sgi.com>
Message-ID: <alpine.LFD.1.00.0804091507480.3243@woody.linux-foundation.org>
References: <Pine.SGI.3.96.1080409163241.8706317L-100000@fergus.americas.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Apr 2008, Alan Mayer wrote:
>
> -	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
> +	set_intr_gate(alloc_system_vector(RESCHEDULE_VECTOR), reschedule_interrupt);

Can we please just merge that syntax and make a single function like

	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);

instead?

		Linus
