Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXLQMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXLQMeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXLQMeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:34:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXLQMef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:34:35 -0500
Subject: Re: Top kernel oopses/warnings this week
From: Jon Masters <jcm@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
In-Reply-To: <20071217025129.GA12815@redhat.com>
References: <4762CF8C.90808@linux.intel.com>
	 <4763F771.10105@s5r6.in-berlin.de>  <20071217025129.GA12815@redhat.com>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Mon, 17 Dec 2007 07:33:34 -0500
Message-Id: <1197894814.18713.36.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-16 at 21:51 -0500, Dave Jones wrote:
> On Sat, Dec 15, 2007 at 04:49:05PM +0100, Stefan Richter wrote:
>  
>  > Reports about tainted kernels have arguably less value.  It would be
>  > good to hide such reports until a report of the same oops in an
>  > untainted kernel was found.
>  
> I disagree with this.  It's useful to have a "we've seen this before,
> and every time, it was tainted with xyz module" datapoint, especially
> if no untainted copies of that oops turn up.

+1

In fact, that's even more useful in many cases, if it helps demonstrate
that the oops is associated with a particular buggy binary driver. I can
see a lot of potentially interesting statistics coming from that too.

Jon.


