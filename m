Return-Path: <linux-kernel-owner+w=401wt.eu-S1030390AbXCFJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390AbXCFJ3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030389AbXCFJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:29:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030390AbXCFJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:29:18 -0500
Date: Tue, 6 Mar 2007 09:29:17 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Brown <dmlb2000@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070306092917.GA5226@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Brown <dmlb2000@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 03:55:06PM -0800, David Brown wrote:
> I was rtfc'ing the code one day and noticed somethings about the
> PAGE_SIZE define that is kinda inconsistent around its relative
> location to the __KERNEL__ define.
> 
> On some architectures the PAGE_SIZE is outside the __KERNEL__ define
> (i386 and x86_64) and on others its inside the define (ia64 and
> powerpc).  I was wondering if this is because the powerpc and ia64
> architectures have dynamic page sizes so that's why they can't export
> PAGE_SIZE outside __KERNEL__.
> 
> I'm kinda wondering how I'm supposed to write portable user-space code
> if I want to use the PAGE_SIZE define on different architectures.

PAGE_SIZE should not be available at all.  Please use getpagesize()
instead.
