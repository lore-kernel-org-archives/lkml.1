Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXFFIAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXFFIAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXFFIAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:00:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbXFFIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:00:21 -0400
Date: Wed, 6 Jun 2007 01:00:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>, peterz@infradead.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070606010002.2ff6fc98.akpm@linux-foundation.org>
In-Reply-To: <20070606005610.a8c783ce.pj@sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<1181110846.7348.154.camel@twins>
	<alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
	<1181113753.7348.164.camel@twins>
	<alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
	<20070606003421.1107a8bf.pj@sgi.com>
	<alpine.DEB.0.99.0706060042550.15316@chino.kir.corp.google.com>
	<20070606005610.a8c783ce.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 00:56:10 -0700 Paul Jackson <pj@sgi.com> wrote:

> David wrote:
> > That is, unless you can guarantee this type of problem will not happen again
> 
> Well, I certainly cannot guarantee that.

The only place I can think of where the kernel will sit there allocating
huge amounts of memory like this is in readahead.
