Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbZGIHDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbZGIHDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZGIHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:00:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956AbZGIHAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <20090709062906.GA14804@feather>
References: <1246873983.20908.0.camel@johannes.local>
	 <19f34abd0907081228p541d1cdao85f37aaa479fcfc5@mail.gmail.com>
	 <20090709062906.GA14804@feather>
Date: Thu, 9 Jul 2009 09:00:02 +0200
Message-ID: <154e089b0907090000r54dc2436ta25b58395a04acc@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-sparse@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 08:29, Josh Triplett<josh@joshtriplett.org> wrote:
> [Adding Linus and Chris Li to CC; Linus for further background on
> -Wdo-while, and Chris Li for Sparse.]
>
> On Wed, Jul 08, 2009 at 09:28:24PM +0200, Vegard Nossum wrote:
>> 2009/7/6 Johannes Berg <johannes@sipsolutions.net>:
>> > Whether or not the sparse warning
>> >
>> > warning: do-while statement is not a compound statement
>> >
>> > is justified or not in this case, it is annoying and
>> > trivial to fix.
> [...]
>>
>> I'll change the patch title to "kmemcheck: work around bogus sparse
>> warning" and fix the indentation, sounds ok?
>>
>> Meanwhile, I Cced sparse mailing list in case somebody else knows
>> anything else about this warning (what it means, whether it's
>> justified in this case, whether it should be fixed in sparse, etc.).
>
> -Wdo-while gives a warning if you write:
>
> do
>    statement
> while (...);
>
> where "statement" does not consist of a compound statement surrounded by
> braces.  As far as I know, this warning exists primarily because it
> matched Linus's preference for readability.

see:
http://lkml.org/lkml/2008/12/23/180

an related messages/threads

Cheers,
-Hannes
