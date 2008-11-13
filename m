Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYKMXco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYKMXco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYKMXce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:32:34 -0500
Received: from dmz4.indranet.co.nz ([203.97.93.68]:52204 "EHLO
	XServe-2.services.indranet.co.nz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751802AbYKMXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:32:33 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2008 18:32:33 EST
Date: Fri, 14 Nov 2008 12:26:19 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
X-X-Sender: derek@kauri.acheron.indranet.co.nz
To: Pavel Roskin <proski@gnu.org>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       madwifi-project@venema.h4ckr.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [madwifi-project] [RFC] Closing the project
In-Reply-To: <1226610718.2904.23.camel@dv>
Message-ID: <alpine.DEB.1.00.0811141207010.7976@kauri.acheron.indranet.co.nz>
References: <2576.194.45.26.221.1226491274.squirrel@webmail.madwifi.org> <1226511194.9952.38.camel@dv> <43e72e890811121224w4fc53e1s29080a42111186e9@mail.gmail.com> <1226547092.11785.49.camel@dv> <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
 <1226609316.2904.18.camel@dv> <43e72e890811131254q35ff4f48xf58c7c26d5c9a5a4@mail.gmail.com> <1226610718.2904.23.camel@dv>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Pavel Roskin wrote:
> On Thu, 2008-11-13 at 12:54 -0800, Luis R. Rodriguez wrote:
>> On Thu, Nov 13, 2008 at 12:48 PM, Pavel Roskin <proski@gnu.org> wrote:

>>>> Just my advice: let MadWifi die already, stop wasting your time.
Good advise.


> Specifically for me - just three letters.  DFS.
Why are you worried about DFS?
There is only one feature that is important:
  Reliability. It has to work for months, without rebooting.

Consider a very reasonable use of madwifi - in a linux router. It has to
work reliably - without being rebooted by the user.
Consider an AP box that had madwifi in it. Every couple of days, the user
has to reboot it to get the box to work again. The user gets upset and 
returns the box. This is not a commercial product. Yes, the box did DFS, 
but it had to be rebooted regularly.
While the DFS is nice - it is not reliable.

Now - you have noticed the comments about SMP issues in this thread.
Do you know what that implies? There are races races races in the code.
There are contention issues. What is the only reliable fix for SMP?
complete redesign. Pull the code apart - and work out what each tasklet 
and interrupt does. Ensure there is no contention.


Have you noticed the long standing bugs in the bug tracker? Stuck beacon, 
ping ramping in adhoc. Do you know why these bugs are long standing?
Cause noone has the skill/ability/knowledge to fix them. ((Sure, there is 
a purported fix for ping ramping - but this fixes the symptom, not 
cause)). I have a fix for ping ramping - it required a complete redesign 
of the codebase. I can report it, and give you the code, but you cannot 
use it in madwifi cause it breaks wds, scanning, dfs, ap, sta modes.

The options are clear::
  a)Fix stabilise madwifi
or
  b)add features to mac80211

a is a lot of work in a short lived project
b is a lot of work in a project that is going to be around for years.

===================================
Sure, if we abandon development on madwifi - we are breaking our promise.

Given the current rate of development, we will not be able to provide a
stable reliable code base with DFS etc in the promised timescale. thus, if 
we continue developing madwifi, we will fail to meet objective, and end up
breaking our promise in the future.

Conclusion:: break the promise now, or later.

As an end user of madwifi, it is more reasonable to break the promise now.

I end up being forced to agree with Luis:
>>>> Just my advice: let MadWifi die already, stop wasting your time.


Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/
