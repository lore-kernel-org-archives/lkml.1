Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbXFEWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbXFEWkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:40:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43439 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765692AbXFEWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:40:44 -0400
Date: Tue, 5 Jun 2007 15:40:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@cthulhu.engr.sgi.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051540001.5948@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> Reverts git commit c596d9f320aaf30d28c1d793ff3a976dee1db8f5.
> 
> OOM-killed tasks, marked as TIF_MEMDIE, should not be able to access 
> memory outside its cpuset because it could potentially cause other 
> exclusive cpusets to OOM themselves.

Those terminating tasks need that memory to terminate properly right?
