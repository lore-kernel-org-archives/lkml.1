Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXK0Xc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXK0Xc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbXK0Xcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:32:50 -0500
Received: from gw.goop.org ([64.81.55.164]:49841 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbXK0Xct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:32:49 -0500
Message-ID: <474CA923.9080207@goop.org>
Date: Tue, 27 Nov 2007 15:32:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: clean up bitops-related warnings
References: <20071127230124.271668615@goop.org> <20071127230130.508648745@goop.org> <200711280017.33344.ak@suse.de>
In-Reply-To: <200711280017.33344.ak@suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 28 November 2007 00:01:26 Jeremy Fitzhardinge wrote:
>   
>> Add casts to appropriate places to silence spurious bitops warnings.
>>     
>
> Looks a bit ugly. Perhaps it would be better to define standard wrappers
>
> clear_bit_unaligned/any/bettername() etc. ?

Well, most of the casts are already in wrapper functions.  The
setup_64.c ones are ugly, but the following patch cleans them up.

    J

