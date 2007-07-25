Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXGYUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXGYUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYUjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:39:25 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:33276 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbXGYUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:39:25 -0400
Message-ID: <46A7B4DE.4030301@nortel.com>
Date: Wed, 25 Jul 2007 14:38:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tong Li <tong.n.li@intel.com>, linux-kernel@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu>
In-Reply-To: <20070725192442.GC4463@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2007 20:38:57.0529 (UTC) FILETIME=[D2FD7E90:01C7CEFB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> the 3s is the problem: change that to 60s! We no way want to 
> over-migrate for SMP fairness, the change i did gives us reasonable 
> long-term SMP fairness without the need for high-rate rebalancing.

Actually, I do have requirements from our engineering guys for 
short-term fairness.  They'd actually like decent fairness over even 
shorter intervals...1 second would be nice, 2 is acceptable.

They are willing to trade off random peak performance for predictability.

Chris

