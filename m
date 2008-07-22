Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYGVSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYGVSuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYGVSuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:50:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYGVSuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:50:07 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
References: <487E8CE4.70105@redhat.com>
	<1216259391.3358.85.camel@localhost.localdomain>
	<1216304290.5515.11.camel@localhost.localdomain>
	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	<y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	<1216325546.5515.63.camel@localhost.localdomain>
	<20080717202634.GI18295@redhat.com>
	<1216328769.5515.78.camel@localhost.localdomain>
	<20080717213355.GJ18295@redhat.com>
	<20080722140015.37628ea4@bree.surriel.com>
	<20080722181101.GC9508@redhat.com>
	<1216751477.7257.115.camel__19834.5970632092$1216751567$gmane$org@twins>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jul 2008 14:48:27 -0400
In-Reply-To: <1216751477.7257.115.camel__19834.5970632092$1216751567$gmane$org@twins> (Peter Zijlstra's message of "Tue, 22 Jul 2008 20:31:17 +0200")
Message-ID: <y0mej5l92mc.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> [...]
>> > You will have to weigh that against the benefits of making
>> > systemtap generally useful for kernel developers [...]
>> 
>> Understood & agreed, Rik.  If an issue arises where there is genuine
>> conflict between kernel-developer-usability and something else, we'll
>> try to solve it favouring the former if at all possible.
>> 
>> (The kprobes addressing argument cannot reasonably be placed into this
>> category.)

> You have your viewpoint inverted, if the kernel developers think you
> have a problem, and you fail to address it, they will walk away.
>
> If you want the kernel people to endorse your project, you'll have
> to please them. It's that simple. [...]

We have and will try to accomodate anything reasonable.  I trust no
one is suggesting that every systemtap-related suggestion from lkml is
to be treated as if infallible, and that we can continue to debate the
wisdom of each idea on its merits.

- FChE
