Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXF2PcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXF2PcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbXF2Pby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:31:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbXF2Pbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:31:53 -0400
Message-ID: <468525C8.2010407@redhat.com>
Date: Fri, 29 Jun 2007 11:31:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Wrong cache size reported on Q6600
References: <200706290931.45355.kernel@kolivas.org> <20070628233312.GB30594@linux-os.sc.intel.com> <200706290957.08128.kernel@kolivas.org>
In-Reply-To: <200706290957.08128.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 07:57 PM, Con Kolivas wrote:
> On Friday 29 June 2007 09:33, Siddha, Suresh B wrote:
>> On Fri, Jun 29, 2007 at 09:31:44AM +1000, Con Kolivas wrote:
>>> This is a Q6600 which has cache size of 8 MB. Unless it's reporting each
>>> half's effective L2, I think it should be reporting 8192 instead of 4096.
>> There are two L2's, each of 4MB. Each L2 shared by two cores.
> 
> That was what I wasn't sure of as I said above; thanks for clarifying.
> 

You really need to look in /sys/devices/system/cpu/cpuX/cache/ to get
any kind of useful information.

