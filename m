Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbYBNU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbYBNU0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763057AbYBNU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:26:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40490 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762749AbYBNU0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:26:02 -0500
Message-ID: <47B4A3D7.7040007@sgi.com>
Date: Thu, 14 Feb 2008 12:25:59 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com> <200802142102.41420.ak@suse.de> <Pine.LNX.4.64.0802141206100.1041@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802141206100.1041@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 14 Feb 2008, Andi Kleen wrote:
> 
>> You're saying the kernel should use these relative masks internally?
> 
> There is just some thoughts about this. Did not have time to look into the 
> details. Mike?

There are a few places where the entire cpumask is not needed.  For
example, in the area of core siblings on a node.  There's a limit
to how many cores/threads can be on a node and the full 4k cpumask
is not needed.  How this pertains to this new functionality I'm
not sure yet.

>  
>> That means it would be impossible to run workloads that use the complete
>> machine because you couldn't represent all nodes.
> 
> Not sure how they are addressing this.

