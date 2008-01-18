Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYARVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYARVFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbYARVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:05:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYARVFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:05:09 -0500
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Remove CONFIG_X86_TSC for 32bit II
From: Andi Kleen <andi@firstfloor.org>
References: <20080118627.198787000@suse.de>
	<20080118172721.96C8B14AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 22:05:08 +0100
In-Reply-To: <20080118172721.96C8B14AAE@wotan.suse.de> (Andi Kleen's message of "Fri\, 18 Jan 2008 18\:27\:21 +0100 \(CET\)")
Message-ID: <p73tzlaalq3.fsf_-_@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> The config option protects so little code that it is fairly pointless.
> Also a lot of its code was related to itself only (as in panicing without
> TSC). And TSC less CPUs are completely handled at runtime anyways.
>
> This makes 32bit behaviour match x86-64.
>
> I also removed an #if defined(CONFIG_X86_GENERIC) in get_cycles. Not sure
> what that was good for, it didn't make any sense.

Hmm, during further testing i found that the patch causes boot failures
in some configuration. I withdraw this one for now.

The other patches in the series are independent and should be still
considered for merging.

-Andi
