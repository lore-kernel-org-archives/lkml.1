Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZLTErL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZLTErL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 23:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZLTErJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 23:47:09 -0500
Received: from mail.tmr.com ([64.65.253.246]:60026 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbZLTErI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 23:47:08 -0500
Message-ID: <4B2DAC40.7090302@tmr.com>
Date: Sat, 19 Dec 2009 23:46:56 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Con Kolivas <kernel@kolivas.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
References: <200912111124.18118.kernel@kolivas.org> <200912120204.51547.kernel@kolivas.org> <alpine.DEB.2.00.0912110910490.32415@router.home> <200912120937.42943.kernel@kolivas.org>
In-Reply-To: <200912120937.42943.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Sat, 12 Dec 2009 02:12:58 Christoph Lameter wrote:
>> On Sat, 12 Dec 2009, Con Kolivas wrote:
>>> On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
>>>> Could you make the scheduler build time configurable instead of
>>>> replacing the existing one? Embedded folks in particular may love a low
>>>> footprint scheduler.
>>> It's not a bad idea, but the kernel still needs to be patched either way.
>>> To get BFS they'd need to patch the kernel. If they didn't want BFS, they
>>> wouldn't patch it in the first place.
>> BFS would have a chance to be merged as an alternate scheduler for
>> specialized situations (such as embedded or desktop use).
>>
> 
> Nice idea, but regardless of who else might want that, the mainline 
> maintainers have already made it clear they do not.
> 
Since your work is going in as a patch anyway, who is it that cares? The point 
is that I have one source which I compile with multiple config files, rather 
than multiple sources I get to patch with selected embellishments from -mm and 
-next and other places.

It would be great if the system could boot and run on a doorknob scheduler long 
enough to load a scheduling modules at boot time. But that's a second level gain 
to having a single source and compiling the hell out of it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
