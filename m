Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbZJISGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbZJISGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760530AbZJISGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:06:39 -0400
Received: from bu3sch.de ([62.75.166.246]:35140 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbZJISGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:06:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: b43: do not stack-allocate pio rx/tx header and tail buffers (was: pull request: wireless-2.6 2009-10-08)
Date: Fri, 9 Oct 2009 20:05:58 +0200
User-Agent: KMail/1.9.9
Cc: bcm43xx-dev@lists.berlios.de, linux-netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200910062252.17565.mb@bu3sch.de> <4ACCD765.7080604@lwfinger.net> <4ACF76F7.30406@yahoo.es>
In-Reply-To: <4ACF76F7.30406@yahoo.es>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910092005.59916.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009 19:46:31 Albert Herranz wrote:
> I'm not arguing if the patch should have been immediately merged upstream or not without your ack (I'm probably more on your side here, as the patch was still being discussed on the ML).
> The patch [1] may not be up to your quality standards or may not take into account other requirements (that you have not expressed nor on the ML nor on IRC) but I'm sure it's far from being "random", "move crap" or "add stupid comments". That's the unfair part.
> 
> The reason I posted the initial patch for review was because you kind of told me [2].
> 
> [20:06] <mb_> Anyway, I'm not going to fix this. If you need it fixed, please send patches

Yeah, but that doesn't mean that either hack is acceptable. It just means that my time is limited
and I added this non-issue (which I still think it is) to the very bottom of my priority list.

> After ~22 hours if I'm not mistaken (yes, less than 24...) John, who had previously expressed his intentions to merge the patch [5], picked it for wireless-2.6.
> And a day later, more or less again, John did the GIT PULL request.

My impression was, that if the maintainer rejects a patch and asks for a new version,
the upstream maintainer must not take the patch until the maintainer acked the new version.
It seems I was wrong, though.

> My point here is that there's no reason for such strong words concerning the quality of the patch code. It's really not that bad for such wording.
> I'm sure that if the patch was really crap it would have been immediately NAK'ed by you or by any sane maintainer.

It _was_ immediately NAK'ed by me. I did not know that I need to NAK
every single new version of a patch explicitely.
I thought NAK-ing a patch would put it into some special state that only an explicit ACK could
take it out of.

-- 
Greetings, Michael.
