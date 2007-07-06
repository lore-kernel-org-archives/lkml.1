Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbXGFPev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbXGFPev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbXGFPen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:34:43 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37723 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403AbXGFPen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:34:43 -0400
Message-ID: <468E6103.5080706@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2007 08:34:27 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Pavel Emelianov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [-mm PATCH 0/7] Memory controller introduction
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop> <468CB658.7000204@openvz.org> <1183727690.7054.104.camel@twins>
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
> 
> 
> 

Peter, 

In these patches, we provide memory control that includes
mapped pages and unmapped pages (as discussed in the BOF). All memory
is treated uniformly. We will not have separate page cache control,
what we can have is control for either mapped pages or control
for a combination of mapped and unmapped pages together.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
