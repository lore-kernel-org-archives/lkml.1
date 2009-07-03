Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZGCTMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZGCTMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbZGCTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:11:54 -0400
Received: from claw.goop.org ([74.207.240.146]:47243 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbZGCTLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:11:53 -0400
Message-ID: <4A4E57FA.4000609@goop.org>
Date: Fri, 03 Jul 2009 12:11:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <4A4E54A8.4030606@goop.org> <200907031403.34566.lkml@morethan.org>
In-Reply-To: <200907031403.34566.lkml@morethan.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/09 12:03, Michael S. Zick wrote:
> Random system halts, deadlocks with interrupts disabled?
> Yup, that sounds familiar.
>   

No, mostly memory corruption, with all sorts of indicative kernel
messages (esp if you have all the debugging options on). 

But my point is that if there were something wrong in that particular
piece of code, it would have very widespread effects.  It would not be
subtle in the sense of only affecting one or two people.

> If I ever get more than a stopped machine with a glowing power light;
> I will be certain to share.
>   

Hm, well that does sound serious, but I think you're barking up the
wrong tree with this particular patch.

    J
