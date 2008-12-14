Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYLNMzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYLNMzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 07:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYLNMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 07:55:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59160 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYLNMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 07:55:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494501FE.9000304@s5r6.in-berlin.de>
Date: Sun, 14 Dec 2008 13:54:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: "BUG: MAX_STACK_TRACE_ENTRIES too low!" - reason for concern?
References: <tkrat.7ea353e737215fa2@s5r6.in-berlin.de> <1229258485.17130.8.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1229258485.17130.8.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2008-12-14 at 02:38 +0100, Stefan Richter wrote:
[unload/ reload drivers]
>> Dec 14 01:23:29 stein BUG: MAX_STACK_TRACE_ENTRIES too low!
> 
> lockdep resource allocation is pretty simple wrt to modules, it will not
> re-use anything, therefore cycling modules will let it run out of its
> resources pretty quickly.
> 
> I suppose one could go add all kinds of smart and complicate the whole
> thing, but I'm not sure its worth it.

OK, no problem.  I have another test PC which I apparently reboot often
enough to stay under this limit.  Thanks for the clarification.
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/
