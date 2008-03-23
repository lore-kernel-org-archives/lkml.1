Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYCWDjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYCWDjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 23:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYCWDjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 23:39:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYCWDjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 23:39:36 -0400
Message-ID: <47E5D0B6.6090307@redhat.com>
Date: Sat, 22 Mar 2008 23:38:30 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: wait until PHY configuration packet was transmitted
References: <tkrat.47c2348a94015e02@s5r6.in-berlin.de> <200803212312.41277.jwilson@redhat.com> <47E4DDFB.4050600@s5r6.in-berlin.de>
In-Reply-To: <47E4DDFB.4050600@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Jarod Wilson wrote:
>> Will double-check Monday that this solves never-ending (until panic) bus
> 
> s/that/whether/? :-)

Either one works here. I went with "that", because I'm reasonably 
certain that it does solve the problem and I'll just be confirming it, 
vs. suspecting it might and finding out whether it does or not... Or 
something like that. :)

>> resets with a jmicron controller in the office, but this does indeed 
>> prevent a very similar looking case with a via vt6307 ohci 1.0 
>> controller + iogear hub + unibrain fire-i camera:
>>
>>   http://bugzilla.kernel.org/show_bug.cgi?id=10128
> 
> The wonders of brainstorming on IRC.  Let's implement all far-off and 
> weird ideas we can possibly get, distill those which don't cause 
> regressions, and we will end up with perfectly working drivers. :-)

Definitely! We've certainly been getting closer and closer, anyhow...

-- 
Jarod Wilson
jwilson@redhat.com
