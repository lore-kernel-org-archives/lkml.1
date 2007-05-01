Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXEAPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXEAPLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXEAPLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:11:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbXEAPKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:10:22 -0400
Message-ID: <463757A3.7010808@redhat.com>
Date: Tue, 01 May 2007 11:07:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, akpm@osdl.org, gcoady@gmail.com, zlynx@acm.org,
       dgc@sgi.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       hch@infradead.org, jengelh@linux01.gwdg.de, zwane@infradead.org,
       neilb@suse.de, jens.axboe@oracle.com, eric@provenscaling.com
Subject: Re: [3/3] use vmalloc() to arrange guard pages for stacks
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com> <20070430233712.GI26598@holomorphy.com> <20070430234030.GJ26598@holomorphy.com>
In-Reply-To: <20070430234030.GJ26598@holomorphy.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> This patch introduces CONFIG_DEBUG_STACK, which vmalloc()'s task and IRQ
> stacks in order to establish guard pages. In such a manner any stack
> overflow that references pages immediately adjacent to the stack is
> immediately trapped with a fault, which precludes silent memory corruption
> or difficult-to-decipher failure modes resulting from stack corruption.
> 

Is there a guard page below and above the stack? (I've seen stack underflow
before, as well as overflow.)
