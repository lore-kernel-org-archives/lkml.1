Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXCQM0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXCQM0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCQM0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:26:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:39669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbXCQM0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:26:07 -0400
To: tglx@linutronix.de
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@infradead.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] i386: trust the PM-Timer calibration of the local APIC timer
References: <200703161230.03712.maximlevitsky@gmail.com>
	<1174088686.13341.347.camel@localhost.localdomain>
	<1174089896.13341.362.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Mar 2007 14:24:53 +0100
In-Reply-To: <1174089896.13341.362.camel@localhost.localdomain>
Message-ID: <p73ps786lzu.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> When PM-Timer is available for local APIC timer calibration we can skip
> the verification of the calibrated time value. The resulting error is
> quite small on a bunch of evaluated platforms and is less harming than
> the observed false positives.

Looks good to me.

-Andi
