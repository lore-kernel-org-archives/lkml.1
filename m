Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYATEqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYATEqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 23:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYATEqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 23:46:08 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42131 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYATEqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 23:46:07 -0500
Message-ID: <4792D221.1010704@davidnewall.com>
Date: Sun, 20 Jan 2008 15:16:25 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org>
In-Reply-To: <20080120031153.GB6275@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jan 20, 2008 at 12:57:29PM +1030, David Newall wrote:
>   
>> compatibility.  This is a sleeping giant for Linux.  There are plenty of
>>     
>
> Interesting choice of words.
>   
KFC and Dominoes use SCO for their cash registers, to pick just two
enormous future opportunities.


> But it does not make sense for all Linux kernels to always check for iBCS executables
> when they don't have to code to run them anyways.
>   

I don't suppose you're suggesting this will make a big difference.  Even
if every exec did nothing but immediately exit, it still wouldn't make
much difference.

Likewise, I take your point about proper iBCS support (and I suppose
it's really iBCS2 that we're talking about.)  My concern is that
removing this now gains almost nothing, 2 strcmp per exec is as close to
nothing as anything, but it sends a message with which I disagree.  The
message should be that Linux is good for, well the same things FreeBSD
is, and includes running Solaris and SCO binaries.  This is a major
simplification of the story, I know, but still hits the plot highlights.
