Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXDJRT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXDJRT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXDJRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:19:28 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:59439 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXDJRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:19:28 -0400
Date: Tue, 10 Apr 2007 19:19:24 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070410171924.GA18314@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461BB092.3070201@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 08:43:14AM -0700, H. Peter Anvin wrote:

> I don't see the point in dealing with one particular corner case,

I wouldn't really call CJK a *corner* case, just think of how many people
use these writing systems.

Theoretically it's just one particular case, I agree. In practice, however,
this case occurs relatively often compared to all the nontrivial cases a
full-featured terminal should cope with.

> especially a corner case for which font support is inherently impossible.

I'd not make this chance to properly display CJK. I'd make this change to
properly display and to be able to edit English letters that happen to
follow some CJK within the same row.

> It's bloat.

What do you exactly mean by this? Doing a binary search in a table of 11
intervals to find out whether a character is double-wide? Adding
approximately 30 lines of code (including the table and the binary search
routine) to the kernel to handle this case? I don't think it's bloat. It's a
small, simple, easy to understand piece of code that would make the kernel
slightly better, and in some cases would make the users' life easier by
letting some text editors work correctly in one not-so-special case. Why not
then?

If there's no chance to make something perfect then isn't it worth it to
improve that? I don't think so.

I still haven't heard any arguments from you that the resulting *behavior*
would be worse in any respect. I have arguments that it'd be better. It's
only 30 lines of code... And even if it's a bloat, it wouldn't be the first
one in the kernel, would it? :-) A "bloat" that makes it better...


Opinions from anyone else, maybe?


I already have fixes to the UTF-8 decoder, but I still have to adjust that
patch according to what we've already discussed. I really want this CJK
issue to get accepted, unless I'm convinced that it has drawbacks. I am
happy to discuss and argue, but I'm not going to fight (I hope the
difference is clear). So please don't be on my way unless you do have a good
reason. If possible, I don't want to create two incremental patches either
(first for the decoder, second for the double-width) because it does take
some valuable time for me to stress-test each and every patch before I send
it. On the other hand, I don't know what's really needed for a patch to be
accepted. How much your word counts, for example. (I guess it counts much,
being almost the only person with worthful comments on the topic.) How much
do my chances change if I include the CJK part? I don't know...

I'd be very glad if -- based on my arguments -- you changed your mind and
wouldn't be _against_ this feature. A "don't care" state would be perfect
for me :-)



-- 
Egmont
