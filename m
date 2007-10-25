Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbXJYPek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbXJYPek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXJYPed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:34:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbXJYPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:34:32 -0400
Date: Thu, 25 Oct 2007 08:34:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Permit silencing of __deprecated warnings.
In-Reply-To: <20071025011516.aea17222.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710250833450.30120@woody.linux-foundation.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
 <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
 <20071025011516.aea17222.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Andrew Morton wrote:
> 
> Sigh.  Can't we just fix the dud code?  Or mark it BROKEN and see what
> happens?

I think removing __deprecated is the better option.

Quite frankly, some people add "__deprecated" *way* too eagerly. 

			Linus
