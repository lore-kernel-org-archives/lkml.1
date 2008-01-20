Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbYATGXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbYATGXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 01:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbYATGXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 01:23:17 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42152 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbYATGXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 01:23:16 -0500
Message-ID: <4792E8E2.1090307@davidnewall.com>
Date: Sun, 20 Jan 2008 16:53:30 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org>
In-Reply-To: <20080120055544.GB19861@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jan 20, 2008 at 04:03:22PM +1030, David Newall wrote:
>   
>> It's not necessarily that simple.  It might be for KFC and Dominoes, but
>> for others, SCO is not the complete story.  Many legacy systems are
>> written in COBOL, and must pay a per-seat licence for that on top of the
>> per-seat licence for UNIX.  It is these systems that are most attracted
>> towards SCO compatibility.
>>     
>
> Well I'm sure if they migrate they can either recompile or pay someone
> to forward port and apply and support the iBCS emulation patchkit.
>   
If they migrate they buy a new run-time licence.  These costs about a
thousand dollars for small sites.

> But assuming there is no cache miss (which is a very conservative
> assumption) and the strcmps cost 20 cycles and you got 1 million
> 2Ghz Linux systems out there doing 100k execs each day we're talking
> about 1000 CPU seconds wasted each day.
That's not a very useful metric.  It says nothing about what the benefit
will be.  Will any job complete sooner?  Not measurably.  Will less
hardware be required?  No.

> (e.g. the old default ldt code which was for iBCS was just dropped --
> strangely you didn't raise your voice against that)
>   
I wasn't around then, or I would have.

>>  Perhaps KFC could
>> employ somebody to add it, but they'd more likely be able to convert
>> their entire software stack instead.  The paint shops and mechanics of
>> the world would have little chance of that.
>>     
>
> Sorry, but I don't think you know what you're talking about here.
I think I do.  You appear to be arguing that small businesses, such as
paint shops or garages, could re-install iBCS2 support.  That is, of
course, a nonsense in any other sense other than the purely theoretical,
devoid as it is of realities such as--and this is just the most
obvious--a sound business case.  It's just not going to happen that
way.  Perhaps it's best we all ignore the outburst.


I've stated the disadvantage, such as it is, in removing iBCS.  What's
the benefit?  Is it, as I say, a tiny performance improvement per exec
versus removing an itch that leads towards market domination? :)
