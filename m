Return-Path: <linux-kernel-owner+w=401wt.eu-S1766828AbXDSQD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766828AbXDSQD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766836AbXDSQD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:03:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49390 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766828AbXDSQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:03:58 -0400
Date: Thu, 19 Apr 2007 09:03:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <46271FB7.9030408@google.com>
Message-ID: <Pine.LNX.4.64.0704190901250.11728@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
 <4626CEDA.7050608@google.com> <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
 <46271FB7.9030408@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Ethan Solomita wrote:

> > Hmmmm.... Sorry. I got distracted and I have sent them to Kame-san who was
> > interested in working on them. 
> > I have placed the most recent version at
> > http://ftp.kernel.org/pub/linux/kernel/people/christoph/cpuset_dirty
> >   
> 
>    Do you expect any conflicts with the per-bdi dirty throttling patches?

You would have to check that yourself. The need for cpuset aware writeback 
is less due to writeback fixes to NFS. The per bdi dirty throttling is 
further reducing the need. The role of the cpuset aware writeback is
simply to implement measures to deal with the worst case scenarios.

