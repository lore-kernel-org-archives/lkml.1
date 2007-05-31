Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbXEaJkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbXEaJkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbXEaJj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:39:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:43968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbXEaJj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:39:57 -0400
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
References: <20070530105936.6c988da5.akpm@linux-foundation.org>
	<20070530112056.0aeb9498@freepuppy> <465DC598.5060407@trash.net>
	<20070530.125551.41636333.davem@davemloft.net>
	<20070530133039.7feb2064@freepuppy>
	<20070530213541.GA13953@linux-os.sc.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 12:36:26 +0200
In-Reply-To: <20070530213541.GA13953@linux-os.sc.intel.com>
Message-ID: <p73ejkxe0ut.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
> 
> If this does not work:
> Another option is to use 'deferrable timer' here which will be called at
> same as before time when CPU is busy and on idle CPU it will be delayed until
> CPU comes out of idle due to any other events.

That would sound like a good idea here and at least power wise 
it should be nearly free

-Andi
