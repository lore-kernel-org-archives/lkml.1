Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXI0NAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXI0NAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXI0NAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:00:30 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:55306 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbXI0NAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:00:30 -0400
Message-ID: <46FBA95E.3090207@tiscali.nl>
Date: Thu, 27 Sep 2007 15:00:14 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070926164159.3b43479b.randy.dunlap@oracle.com> <20070927004020.GB29906@linux.intel.com>
In-Reply-To: <20070927004020.GB29906@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Gross wrote:
> On Wed, Sep 26, 2007 at 04:41:59PM -0700, Randy Dunlap wrote:
>> On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross wrote:
>>
>>> The following is the qos_param patch that implements a genralization of
>>> latency.c.
>>>
>> Just some general comments (as on irc):
>>
>> - use 'diffstat -p1 -w70' to summarize each patch
>> - use checkpatch.pl to check for coding style and other buglets
> 
> done
> 
>> - has no API docs  :(
> not done yet.
>>
>>
>>
>>> +/* assumes qos_lock is held */
>>> +static void update_target(int i)
>> I'd prefer a better arg name than 'i'.
> 
> I do too, but i in this case is an Index.

I think in many cases you could use a pointer to qos_array[i] instead of 
passing this index 'i' as a function argument.

Roel
