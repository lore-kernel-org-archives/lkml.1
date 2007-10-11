Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXJKGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXJKGeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXJKGeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:34:04 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:32852 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbXJKGeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:34:02 -0400
Message-ID: <470DC3A4.1000703@linux.vnet.ibm.com>
Date: Thu, 11 Oct 2007 12:03:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: Memory controller merge (was Re: -mm merge plans for 2.6.24)
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <4701C737.8070906@linux.vnet.ibm.com> <20071010170702.34fb3eee@cuia.boston.redhat.com>
In-Reply-To: <20071010170702.34fb3eee@cuia.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Tue, 02 Oct 2007 09:51:11 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> I was hopeful of getting the bare minimal infrastructure for memory
>> control in mainline, so that review is easy and additional changes
>> can be well reviewed as well.
> 
> I am not yet convinced that the way the memory controller code and
> lumpy reclaim have been merged is correct.  I am combing through the
> code now and will send in a patch when I figure out if/what is wrong.
> 

Hi, Rik,

Do you mean the way the memory controller and lumpy reclaim work
together? The reclaim in memory controller (on hitting the limit) is not
lumpy. Would you like to see that change?

Please do share your findings in the form of comments or patches.

> I ran into this because I'm trying to merge the split VM code up to
> the latest -mm...
> 

Interesting, I'll see if I can find some spare test cycles to help test
this code.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
