Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZALXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZALXBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbZALXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:01:09 -0500
Received: from mail.tmr.com ([64.65.253.246]:58805 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbZALXBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:01:07 -0500
Message-ID: <496BCB7A.2010804@tmr.com>
Date: Mon, 12 Jan 2009 18:00:10 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net>
In-Reply-To: <20090112162938.GA22647@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Mon, Jan 12, 2009 at 04:19:31PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>>> Yes, it could be done. If inotify will not be killed itself, will be
>>> enabled in the config and daemon will be started.
>>> But right now there is no way to solve that task, in the long term this
>>> is a good idea to implement modulo security problems it may concern.
>> It is perfectly soluble right now, use the existing /proc interface. If
>> you want to specifically victimise new tasks first then set everything
>> else with an adjust *against* being killed and new stuff will start off
>> as cannon fodder until classified.
>>
>> The name approach is the wrong way to handle this. It has no reflection
>> of heirarchy of process, targetting by users, containers etc.. 
>>
>> In fact containers are probably the right way to do it
> 
> Containers to solve oom-killer selection problem? :)
> 
> Being more serious, I agree that having a simple name does not solve the
> problem if observed from any angle, but it is not the main goal.
> Patch solves oom-killer selection issue from likely the most commonly
> used case: when you know who should be checked and killed first when
> problem appears.
> 
The only cases in which this would really be useful is when running some 
software which once in a great while goes super prompt critical and starts 
throwing processes of a known name format in all directions, or when you have a 
problem and know the process names involved before OOM kills everything in sight.

This does have a strange attraction, I did save the patch in case another "every 
few years" problem comes up.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
