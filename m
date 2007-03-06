Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbXCFAFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbXCFAFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXCFAFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:05:01 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46214 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbXCFAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:04:59 -0500
Date: Mon, 5 Mar 2007 16:01:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David Brown" <dmlb2000@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-Id: <20070305160110.1410b1e7.randy.dunlap@oracle.com>
In-Reply-To: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 15:55:06 -0800 David Brown wrote:

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

use 'getpagesize(2)'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
