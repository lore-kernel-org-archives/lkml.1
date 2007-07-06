Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbXGFOHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbXGFOHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXGFOG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:06:58 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:41541 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXGFOG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:06:58 -0400
Message-ID: <468E4C7C.3050008@openvz.org>
Date: Fri, 06 Jul 2007 18:06:52 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [-mm PATCH 0/7] Memory controller introduction
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop>	 <468CB658.7000204@openvz.org> <1183727690.7054.104.camel@twins>
In-Reply-To: <1183727690.7054.104.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2007-07-05 at 13:14 +0400, Pavel Emelianov wrote:
> 
>> Separate limits for RSS and RSS+pagecache are also a must.
> 
> This I still disagree upon. Page-cache limits are orthogonal to
> containers and not a requirement for containers. If you want such a
> feature get it in Linux proper and don't sneak it in the backdoor via
> containers.

What I wanted to say is that *iff* we need limit for booth the RSS and
the page cache, then we do need a separate limit for the RSS only. I do
not vote for the page cache limit either, but I do not vote _against_ it
as well, and agree to take part in its development.

Thanks,
Pavel.

