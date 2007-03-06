Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXCFDgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXCFDgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXCFDgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:36:44 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:61735 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbXCFDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:36:43 -0500
Date: Mon, 05 Mar 2007 22:36:40 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Message-id: <200703052236.40949.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <200703052123.29421.edt@aei.ca>
 <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Linus Torvalds wrote:
>On Mon, 5 Mar 2007, Ed Tomlinson wrote:
>> The patch _does_ make a difference.  For instance reading mail with
>> freenet working hard  (threaded java application) and gentoo's emerge
>> triggering compiles to update the box is much smoother.
>>
>> Think this scheduler needs serious looking at.
>
>I agree, partly because it's obviously been getting rave reviews so far,
>but mainly because it looks like you can think about behaviour a lot
>better, something that was always very hard with the interactivity
>boosters with process state history.
>
>I'm not at all opposed to this, but we do need:
> - to not do it at this stage in the stable kernel
> - to let it sit in -mm for at least a short while
> - and generally more people testing more loads.
>
>I don't actually worry too much about switching out a CPU scheduler:
> those things are places where you *can* largely read the source code
> and get an idea for them (although with the kind of history state that
> we currently have, it's really really hard). But at the very least they
> aren't likely to have subtle bugs that show up elsewhere, so...
>
>So as long as the generic concerns above are under control, I'll happily
>try something like this if it can be merged early in a merge window..
>
>			Linus

Thanks Linus, now I feel we're getting somewhere.

Cheers, Gene
-- 
Many hands make light work.
		-- John Heywood
