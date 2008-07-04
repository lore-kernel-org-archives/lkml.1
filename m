Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYGDVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYGDVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYGDVWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:22:43 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:6168 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYGDVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:22:42 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Peterson <joe@skyrush.com>, Elias Oltmanns <eo@nebensachen.de>,
       =?utf-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
From: Andi Kleen <andi@firstfloor.org>
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
Date: Fri, 04 Jul 2008 23:21:57 +0200
In-Reply-To: <20080704212335.4ffc8230@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri, 4 Jul 2008 21:23:35 +0100")
Message-ID: <871w29s5u2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jul 2008 21:14:34.0752 (UTC) FILETIME=[F5639800:01C8DE1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> disk activity process over each time it completed), it always broke out
>> after one ^C - one time took an extra second or two.  Note that I did
>> not run latencytop (did not have it compiled in my kernel) - if that is
>> required for the test, let me know, but I assume it is just for
>> gathering info when the issue occurs.
>
> I really don't think this is tty related looking at the code involved and
> also the lack of actual measurements presented. More likely scheduler and
> VM related changes.

Why should the scheduler or VM behave differently for Ctrl-Z+kill 
versus Ctrl-C?

Doesn't make sense to me. And yes I see this here regularly and it started
at some point.

-Andi
