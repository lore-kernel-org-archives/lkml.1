Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXFOPeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXFOPeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXFOPeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:34:02 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43080 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXFOPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:34:01 -0400
Date: Fri, 15 Jun 2007 08:33:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "jidong xiao" <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to printk unsigned long long variable?
Message-Id: <20070615083355.f5bdb784.randy.dunlap@oracle.com>
In-Reply-To: <19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	<19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
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

On Fri, 15 Jun 2007 17:04:00 +0200 Vegard Nossum wrote:

> On 6/15/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> > typedef unsigned long long u64;
> > u64             *dma_mask;
> > Then how to use printk() to print out a dma_mask variable?
> 
> In regular printf(), this would be specified by the format "%llu". Try that?

and cast dma_mask to (unsigned long long), at least in kernel printk()
calls.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
