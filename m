Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYEENqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYEENqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbYEENpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:45:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58317 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218AbYEENpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:45:45 -0400
Message-ID: <481F0F86.50009@firstfloor.org>
Date: Mon, 05 May 2008 15:45:42 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
References: <20080502091806.GA26062@basil.nowhere.org>	 <20080502094543.GA11114@basil.nowhere.org>	 <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de>	 <481EDEC5.10000@firstfloor.org>	 <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>	 <481F0BCD.8020306@firstfloor.org> <84144f020805050642p1e0ca224r9c1a92e899fddfe3@mail.gmail.com>
In-Reply-To: <84144f020805050642p1e0ca224r9c1a92e899fddfe3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Andi,
> 
> On Mon, May 5, 2008 at 4:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>  > Err, it checks the process stack when 4KSTACKS=n
>>
>>  Ok then please add the two changes if you feel strongly about that
>>  (to the latest version I sent).
>>
>>  You always edit my patches anyways (usually driving me crazy when I have
>>  dependent patches because nothing applies anymore when all the variables
>>  got renamed like you often do) so I don't see any reason why you can't
>>  do that here.
> 
> Heh, do you mean to say that all this time I should have just asked
> Andrew to fix all the patches I've submitted rather take the trouble
> to do that myself after the review? ;-)

It is quite ok for trivial changes (like adding KERN_WARN or unlikely).
And yes Andrew does this all the time too. It makes sense because for
such trivialities it is less work to just change the patch than to comment.

-Andi

