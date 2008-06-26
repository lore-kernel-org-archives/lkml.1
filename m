Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYFZPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYFZPh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYFZPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:37:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:43023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYFZPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:37:49 -0400
Date: Thu, 26 Jun 2008 08:37:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.6  kernel BUG at mm/highmem.c:319!
Message-ID: <20080626083749.4fd0b403@infradead.org>
In-Reply-To: <20080626145942.GA25295@redhat.com>
References: <20080626145942.GA25295@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 10:59:42 -0400
Dave Jones <davej@redhat.com> wrote:

> Anyone know how this can happen ?
> We just got a report from a user who is hitting the 
> 
>         BUG_ON(!PageHighMem(page));
> 
> in set_page_address().

we discussed this 2 or 3 weeks ago as part of the kerneloops reports...
everyone is puzzled... it's the number 20 report right now.

http://www.kerneloops.org/search.php?search=set_page_address

it seems that fuse is a very popular module when this hits...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
