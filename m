Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbXJ2UhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbXJ2UhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXJ2Ug6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:36:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55272 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbXJ2Ug6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:36:58 -0400
Date: Mon, 29 Oct 2007 13:36:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, rientjes@google.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071029123558.fb077ca9.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710291336470.1566@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <1193411888.5032.9.camel@localhost> <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com>
 <1193674988.5035.93.camel@localhost> <20071029123558.fb077ca9.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Paul Jackson wrote:

> The more I have stared at this, the more certain I've become that we
> need to make the mbind/mempolicy calls modal -- the default mode
> continues to interpret node numbers and masks just as these calls do
> now, and the alternative mode provides the so called "Choice B",
> which takes node numbers and masks as if the task owned the entire
> system, and then the kernel internally and automatically scrunches
> those masks down to whatever happens to be the current cpuset of
> the task.

Ack.

