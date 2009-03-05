Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZCES3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZCES3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZCES3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:29:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:43567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZCES3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:29:37 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236276274.18136.32.camel@pc1117.cambridge.arm.com>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
	 <1236276274.18136.32.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 19:29:17 +0100
Message-Id: <1236277757.5187.360.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 18:04 +0000, Catalin Marinas wrote:
> 
> BTW, is there a way to know whether the page is in use or on the free
> list? Is page_count(page) feasible?

page_count() == 0, means that the page is not used.
PageBuddy() means its on the freelist.

