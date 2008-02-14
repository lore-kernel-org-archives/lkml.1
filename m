Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbYBNT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbYBNT06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYBNT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:26:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbYBNT0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:26:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
In-Reply-To: Mathieu Desnoyers's message of  Thursday, 14 February 2008 08:27:52 -0500 <20080214132752.GA27478@Krystal>
References: <20080214034541.EF1BD270192@magilla.localdomain>
	<20080214132752.GA27478@Krystal>
Emacs: you'll understand when you're older, dear.
Message-Id: <20080214192643.E1E8E270195@magilla.localdomain>
Date: Thu, 14 Feb 2008 11:26:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sam, is this ok with the samples intent ? I think as long as we do not
> include them with the kernel image and have a "make samples" to build
> them, it's ok. Having them built upon make modules seems like a good
> idea to me.

I"m not sure what you mean by "with the kernel image".  
AFAICT, everything under samples/ can only ever be built as modules.
In no event would it affect the vmlinux link.


Thanks,
Roland
