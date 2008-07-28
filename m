Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYG1WuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYG1WuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYG1WuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:50:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58371 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYG1WuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:50:08 -0400
Message-ID: <488E4D1C.8000906@goop.org>
Date: Mon, 28 Jul 2008 15:50:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: combinatorial explosion in lockdep
References: <20080728.153702.103032029.davem@davemloft.net>
In-Reply-To: <20080728.153702.103032029.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> The triggering event seems to be kstopmachine as done by the first
> module load.  This seems to create the situation where we do double RQ
> locking on essentially all the run queues, in order to move the
> kstopmachine threads around to their proprer cpus.  I think this is
> what starts to make the lockdep dependency chains huge.
>   

Does Rusty's stop_machine rewrite which puts the threads on the correct 
cpus to start with at least mitigate the symptoms?

    J
