Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZDGTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZDGTV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZDGTVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:21:18 -0400
Received: from rtr.ca ([76.10.145.34]:40413 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZDGTVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:21:18 -0400
Message-ID: <49DBA7AB.7020409@rtr.ca>
Date: Tue, 07 Apr 2009 15:21:15 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
References: <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <20090404201820.GA18067@elte.hu> <20090406215034.GD3797@csclub.uwaterloo.ca> <49DB55B9.7030108@rtr.ca> <20090407144801.GR3795@csclub.uwaterloo.ca>
In-Reply-To: <20090407144801.GR3795@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Tue, Apr 07, 2009 at 09:31:37AM -0400, Mark Lord wrote:
>> I generally don't see any delay at all when doing that,
>> even when the Mythtv system is very busy on multiple recordings.
>> But then, I also don't use the huge LIRC stack for the simple R/C either.
> 
> But it happens with the keyboard too. :)
..

Mmm.. now that could be problem.

I wonder if mythfrontend is simply getting paged out of memory,
until you press a button and then the relevant code has to all
get paged back in again before it can respond (?).

