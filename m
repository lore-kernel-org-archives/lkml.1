Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYGBU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYGBU3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYGBU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:28:50 -0400
Received: from mga05.intel.com ([192.55.52.89]:58900 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753381AbYGBU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,739,1204531200"; 
   d="scan'208";a="584440833"
Message-ID: <486BE4EA.5030808@linux.intel.com>
Date: Wed, 02 Jul 2008 13:28:26 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Steven Rostedt <rostedt@goodmis.org>, benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
References: <1214916335.20711.141.camel@pasglop>	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>	 <1215007896.3330.6.camel@localhost.localdomain>	 <20080702200047.GA385@goodmis.org> <1215030120.3330.42.camel@localhost.localdomain>
In-Reply-To: <1215030120.3330.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Easier to implement, yes.  Easier to program, unlikely, and coming with
> a large amount of overhead, definitely.
> 
>> BTW, if something like this is implemented, I think that it should be a
>> replacement for softirqs and tasklets.
> 
under the "better steal right (from other open source) than invent wrong" mantra:
it's worth looking at what glib does here; I've used their threadpools before and
it worked really well for me.... we could learn a lot from that

