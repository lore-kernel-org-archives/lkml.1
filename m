Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXFGICc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXFGICc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXFGICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:02:12 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38261 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbXFGICJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:02:09 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 03:47:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib:  Replace calls to __get_free_pages() with
 __get_dma_pages().
In-Reply-To: <1181118241.7348.173.camel@twins>
Message-ID: <Pine.LNX.4.64.0706070347130.2221@localhost.localdomain>
References: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain> 
 <20070605170601.67bc2939.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706060350040.29202@localhost.localdomain>
 <1181118241.7348.173.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_JL 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Peter Zijlstra wrote:
...
> FWIW I prefer:
>
>   GFP_KERNEL | __GFP_DMA
>   GFP_ATOMIC | __GFP_DMA
>
> and
>
>   GFP_DMA
>
> That is, when used as a modifier use __GFP_, when used as a class
> use GFP_.

that sounds eminently reasonable, i'll go with that.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
