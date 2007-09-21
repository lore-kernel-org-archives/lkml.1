Return-Path: <linux-kernel-owner+w=401wt.eu-S1765502AbXIUVTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765502AbXIUVTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbXIUVTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:19:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbXIUVTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:19:38 -0400
Date: Fri, 21 Sep 2007 17:19:35 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when possible
Message-ID: <20070921211935.GW2625@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <200709211044.901175000@suse.de> <20070921204502.2C61D14EFF@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204502.2C61D14EFF@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:45:02PM +0200, Andi Kleen wrote:
> 
> Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
> the stack can be already unaligned so letting the compiler align
> is useless. This may make some stack frames smaller.

Shouldn't sources that are compiled into the VDSO or VSYSCALL pages
revert this to the default?

	Jakub
