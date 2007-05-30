Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXE3V5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXE3V5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXE3V4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:56:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35883 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760231AbXE3V4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:56:44 -0400
Message-ID: <465DF2A2.2070801@oracle.com>
Date: Wed, 30 May 2007 14:54:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 -mm] slub: use lib/hexdump
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com> <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com> <20070523153730.e0e9e91d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com> <20070523182145.7d7f1f7e.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com> <20070524073131.GA17501@elte.hu> <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com> <20070524142908.f39f42ea.akpm@linux-foundation.org> <20070524145517.1f32cd94.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com> <20070530143451.f4a844bc.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705301443020.3358@schroedinger.engr.sgi.com> <465DF135.80202@oracle.com> <Pine.LNX.4.64.0705301451140.3709@schroedinger.engr.sgi.c!
 om>
In-Reply-To: <Pine.LNX.4.64.0705301451140.3709@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 30 May 2007, Randy Dunlap wrote:
> 
>>> I'd like to keep print_section around as it also does some other things.
>>> Repeating the output formatting at the various call locations will make
>>> it difficult to change if you add another whizbang feature.
>> I have no problems with keeping print_section() except that it's not used
>> in the current tree after this patch.  :)
>>
>>> I have a patch here that I could sent out today if hexdump would work the
>>> right way.
>> Please define "the right way."
> 
> Align the ascii output so that it does not look that ugly.

It's a kernel log file, for crying out loud.  It is not formatted.

but I'll change it  :(

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
