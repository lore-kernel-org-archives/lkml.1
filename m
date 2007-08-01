Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXHAXL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXHAXL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXHAXLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:11:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXHAXLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:11:47 -0400
Date: Wed, 1 Aug 2007 19:10:43 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: smaller kernel with no real time futexes
Message-ID: <20070801231043.GP2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <200708012124.34341.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708012124.34341.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 09:24:34PM +0200, Andi Kleen wrote:
> Adrian,
> 
> You said earlier you're looking at smaller allnoconfig kernels.
> One thing I noticed recently that realtime pi futexes are always
> enabled and that pulls in a lot of other code (like the plists) 
> 
> Userland needs to handle them not being available anyways for older
> kernels.
> 
> Might be worth looking into turning that into a CONFIG.

That's a very bad idea.  glibc configured for 2.6.18 and higher kernels
assumes PI futexes are present.

	Jakub
