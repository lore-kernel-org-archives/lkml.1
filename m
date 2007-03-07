Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXCGKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXCGKZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422715AbXCGKZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:25:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:48835 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422714AbXCGKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:25:41 -0500
Subject: Re: Linux v2.6.21-rc3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:25:32 +0100
Message-Id: <1173263132.9349.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:

> Linus Torvalds (2):
>       Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
>       Linux 2.6.21-rc3

Greg, I think we should revert that patch in 2.6.20.x stable serie too
as get_order is broken there as well, causing random kernel memory
corruption every now and then among others.

Cheers,
Ben

