Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbYBSViP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbYBSViP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYBSVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:37:58 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60036 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754562AbYBSVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:37:57 -0500
Message-ID: <47BB4C33.3030505@sgi.com>
Date: Tue, 19 Feb 2008 13:37:55 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lameter@sgi.com
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
References: <200802162302.04131.yinghai.lu@sun.com> <p73ve4mxxlc.fsf@bingen.suse.de> <47BAFA66.2040603@sgi.com> <20080219180855.GB12010@one.firstfloor.org> <47BB20C6.7050205@sgi.com> <20080219205938.GC13958@one.firstfloor.org>
In-Reply-To: <20080219205938.GC13958@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>> (And of course the problem with cpus on nodes with no local memory
>> needs to be resolved as well.)
> 
> All CPUs get assigned to some node at boot.
> 
> And there should be always per cpu variables or pda to use.

Sorry, I was being vague.  Mel Gorman found a problem that appears
linked to the change to 16-bit apicids on an AMD box that has 4
nodes, but nodes 1-3 have no memory, and the system panics during
cpu_up() on the 2nd cpu which is on node 1.

I've not yet been able to replicate the problem.

Thanks,
Mike
