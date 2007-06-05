Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbXFEIx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbXFEIx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbXFEIxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:53:52 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:41704 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXFEIxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:53:51 -0400
Message-ID: <466523E0.3050605@gmail.com>
Date: Tue, 05 Jun 2007 10:50:40 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2007 01:09 AM, Christoph Lameter wrote:

> Here a version of the patch that drops the WARN_ONs

And now all that's done, how about yet another random person stepping in and 
suggesting NIL or maybe NIL_PTR instead of ZERO_SIZE_PTR?

I understand the idea is that code need not necesarily care about zero sized 
allocation meaning it won't (generally) need to spell it out but it's still a 
dreadful name... :-(

Rene.
