Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYCGIqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYCGIqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCGIqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:46:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbYCGIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:46:15 -0500
Date: Fri, 7 Mar 2008 00:45:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 4/4] mempolicy: remove includes for duplicate
 headers
Message-Id: <20080307004554.3ac5d173.akpm@linux-foundation.org>
In-Reply-To: <20080306150148.2aa87468.pj@sgi.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
	<20080306141923.45ce4214.pj@sgi.com>
	<alpine.DEB.1.00.0803061244560.31802@chino.kir.corp.google.com>
	<20080306150148.2aa87468.pj@sgi.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 15:01:48 -0600 Paul Jackson <pj@sgi.com> wrote:

> David wrote:
> > It simply decreases the remote chance later that ...
> > 
> > The only way this would make things more fragile is if ...
> 
> Does anyone lurking on this thread know if there is an
> established convention in kernel code, whether to directly
> include all headers that your code explicitly needs, or
> whether it's ok to rely on indirect includes for such?
> 
> David and I could debate the fine points of which way is
> best until the cows come home; the two of us are good at
> that.  This is too minor an issue for that sort of effort.
> 

Directly including what you need is more robust than a) relying upon nested
inclusions by includees or b) relying upon preceding inclusions by
includers.

So we usually go that way, when we notice it and when we think about it.

