Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbYD0XIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbYD0XIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYD0XIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:08:40 -0400
Received: from sandeen.net ([209.173.210.139]:27681 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYD0XIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:08:39 -0400
Message-ID: <48150776.4080409@sandeen.net>
Date: Sun, 27 Apr 2008 18:08:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080419142329.GA5339@elte.hu> <20080422012819.GT108924158@sgi.com> <20080427192736.GA21979@logfs.org> <200804280102.01964.vda.linux@googlemail.com>
In-Reply-To: <200804280102.01964.vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Sunday 27 April 2008 21:27, Jörn Engel wrote:
>> On Tue, 22 April 2008 11:28:19 +1000, David Chinner wrote:
>>> On Mon, Apr 21, 2008 at 09:51:02PM +0200, Denys Vlasenko wrote:
>>>
>>>> Why xfs code is said to be 5 times bigger than e.g. reiserfs?
>>>> Does it have to be that big?
>>> If we cut the bulkstat code out, the handle interface, the
>>> preallocation, the journalled quota, the delayed allocation, all the
>>> runtime validation, the shutdown code, the debug code, the tracing
>>> code, etc, then we might get down to the same size reiser....
>> Just noticed this bit of FUD. Last time I did some static analysis on
>> stack usage, reiserfs alone would blow away 3k, while xfs was somewhere
>> below.
> 
> I'm sorry, but it's not what I said.
> I didn't say reiserfs eats less stack. I don't know.
> I said it is smaller.
> 
> reiserfs/*  821474 bytes
> xfs/*      3019689 bytes

FWIW, the reason for that is in large part all the features Dave listed
above, and probably more.

And, while certainly not yet tiny, the recent trend actually is that xfs
is getting a bit smaller:

http://oss.sgi.com/~sandeen/xfs-linedata.png

(note, though - the Y axis does not start at 0)  :)

-Eric
