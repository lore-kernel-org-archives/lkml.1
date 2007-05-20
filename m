Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbXETKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbXETKHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXETKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:07:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49443 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbXETKHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:07:24 -0400
Date: Sun, 20 May 2007 12:03:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andreas Schwab <schwab@suse.de>
cc: Willy Tarreau <w@1wt.eu>, oliver pinter <oliver.pntr@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       Bernd Eckenfels <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
In-Reply-To: <jey7jjx3f5.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.61.0705201201290.9015@yvahk01.tjqt.qr>
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com>
 <E1HpUNW-00020n-00@calista.eckenfels.net> <20070519192021.GK943@1wt.eu>
 <20070519192246.GA11733@1wt.eu> <6101e8c40705191237v46939bf1i7098fc974784de5a@mail.gmail.com>
 <6101e8c40705191250o447e9c59kba824baae4d99b3f@mail.gmail.com>
 <20070519202419.GC2521@1wt.eu> <Pine.LNX.4.61.0705201038250.9015@yvahk01.tjqt.qr>
 <jey7jjx3f5.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.5 points, 6.0 required
	0.5 PLING_QUERY            Subject has exclamation mark and question mark
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20 2007 11:14, Andreas Schwab wrote:
>Jan Engelhardt <jengelh@linux01.gwdg.de> writes:
>> On May 19 2007 22:24, Willy Tarreau wrote:
>>>On Sat, May 19, 2007 at 09:50:43PM +0200, oliver pinter wrote:
>>>> yeah, but how produziert?
>>>
>>>I *think* it is the unbreakable space.
>>
>> \xa0 is 160, aka the NBSP. But __only__ in ISO-8859. It is an invalid
>> UTF-8 sequence (which is why you may not even "see" the nbsp :-)
>
>Actually, in a utf-8 environment you see it much better.

But only if invalid sequences are replaced by a question mark or whatever,
which is not the case in xterm.


	Jan
-- 
