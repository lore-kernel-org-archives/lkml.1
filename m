Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZDUPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZDUPNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZDUPNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:13:37 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:34746 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZDUPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:13:36 -0400
Date: Tue, 21 Apr 2009 11:05:34 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/25] Do not disable interrupts in free_page_mlock()
In-Reply-To: <20090421085007.GG12713@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904211104390.19969@qirst.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-19-git-send-email-mel@csn.ul.ie> <1240300507.771.52.camel@penberg-laptop> <20090421085007.GG12713@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Mel Gorman wrote:

> > Maybe add a VM_BUG_ON(!PageMlocked(page))?
> >
>
> We always check in the caller and I don't see callers to this function
> expanding. I can add it if you insist but I don't think it'll catch
> anything in this case.

Dont add it. Pekka sometimes has this checkeritis that manifest itself
in VM_BUG_ON and BUG_ONs all over the place.

