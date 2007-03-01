Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXCALmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXCALmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbXCALmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:42:18 -0500
Received: from ozlabs.org ([203.10.76.45]:41744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXCALmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:42:17 -0500
Subject: Re: Bug in on_each_cpu?
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hecht <dhecht@vmware.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45E6BA3A.2040306@vmware.com>
References: <45E6AC1A.8050608@vmware.com>
	 <20070301024524.c7c8ea1a.akpm@linux-foundation.org>
	 <45E6BA3A.2040306@vmware.com>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 22:41:18 +1100
Message-Id: <1172749278.10271.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 03:34 -0800, Zachary Amsden wrote:
> What would be really, really nice would be to statically check all 
> callsites that issue irq disables actually keep irqs disabled.  
> Presumably, there was a reason they disabled irqs, and re-enabling them 
> underneath their noses, even if it is to avoid a race, breaks the logic 
> behind that reason.

For the moment, how about a BUG_ON() in on_each_cpu()?

Rusty.


