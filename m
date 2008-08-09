Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYHIWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYHIWB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYHIWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:01:49 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34798 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYHIWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:01:49 -0400
Message-ID: <489E13C0.4010807@keyaccess.nl>
Date: Sun, 10 Aug 2008 00:01:36 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not auto-grab port 0x250
References: <489DE890.1090103@keyaccess.nl> <20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.3 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-08-08 22:46, Alan Cox wrote:

> I have a PMS card. It was the hot technology of 199x about the same
> time as doom came out. I'm probably the only person who still has one
> ;)

Tsss. Lots of people still have doom...

> I'm going to NAK this however because passing in a port is a really
> dumb interface. The PMS card can only be at port 0x250 so if you load
> it there is no doubt and confusion involved.
> 
> The code is fine, the behaviour is correct. Ingo should fix his
> config stuff.

He already did. The deep legacy ones such as this though I myself feel 
are better of just not doing what they do.

> Just apply a tiny bit of rational thought here. There is exactly ONE 
> Ingo.

And as you say yourself -- close to exactly 1 person who still has this 
hardware and closer still to 0 who use it. Really, you contradict yourself:

> He's a smart cookie and can add exception lists to his tester. There
> are millions of users some of whom are brilliant, others are not
> computer wizards. The code should be optimised for them not for Ingo
> - Ingo is an optimisation for the special case not the normal 
> workload!

Millions of users using PMS? I expect you are still going to NAK this 
anyway out of a theoretical standpoint but please stop contradicting 
yourself ;-)

We know this driver breaks the boot during useful kernel work. We know 
that changing it has about a 0.0001% percent change of mattering to 
anyone and then only as long as all those person can't be bothered to 
setup a value in his modprobe.conf.

Now, mind you, I don't care really deeply or anything but this is the 
second time today that I get a comment that places something theoretical 
over something actual. I had deluded myself into thinking that was not 
the way things were done here. Silly me.

Rene.
