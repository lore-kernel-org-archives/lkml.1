Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXFEXU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXFEXU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933768AbXFEXUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:20:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933717AbXFEXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:20:02 -0400
Date: Tue, 5 Jun 2007 16:20:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> No, it means that it can allocate anywhere based on the zonelist ordering 
> and then can OOM a very small exclusive cpuset that would never have had 
> any memory pressure if it wasn't violated.

But the alternative is that the exiting process does not save its 
data.

What is this very small exclusive cpuset?


