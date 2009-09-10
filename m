Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZIJJYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZIJJYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZIJJYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:24:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48504 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZIJJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:24:06 -0400
To: David Miller <davem@davemloft.net>
Cc: paulsheer@gmail.com, linux-kernel@vger.kernel.org, roque@di.fc.ul.pt,
       netdev@vger.kernel.org
Subject: Re: TCP kernel tables overflowing after sustained 1000 new connections per second
From: Andi Kleen <andi@firstfloor.org>
References: <c67e3dc60909091146j4aeaf422v4e0543eff87c7f9a@mail.gmail.com>
	<20090909.170824.141343404.davem@davemloft.net>
Date: Thu, 10 Sep 2009 11:24:04 +0200
In-Reply-To: <20090909.170824.141343404.davem@davemloft.net> (David Miller's message of "Wed, 09 Sep 2009 17:08:24 -0700 (PDT)")
Message-ID: <87k5075f0r.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On a gigabit local LAN I can set the timeouts very low to encourage
> port reuse. A well known configuration issue with all OS's - just search
> for MyOS+TIMED_WAIT on google. No problems here.

The timeouts are what they are for a reason to detect old packets in
the network and prevent data corruption. That's why the RFCs require
them. 

Unless you never run on WANs or have very strong data integry checking
in your application (e.g. SSL) it's normally not a good idea to mess
with them.

When you run out of port space you should use more local IP addresses.

Possibly if you don't have problems with firewalls you could
also increase the port space, but that's still limited.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
