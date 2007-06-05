Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbXFEO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbXFEO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXFEO7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:59:21 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35804 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbXFEO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:59:20 -0400
Message-ID: <46657988.6060901@gmail.com>
Date: Tue, 05 Jun 2007 16:56:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com> <466575EE.70901@goop.org>
In-Reply-To: <466575EE.70901@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2007 04:40 PM, Jeremy Fitzhardinge wrote:

> Rene Herman wrote:

>> No, what we have is a sizeof(pointer) sized pointer pointing to an
>> object of size zero. ZERO_SIZE_PTR is butt-ugly. With a really ugly butt. 
> 
> It doesn't matter.  It will never, ever, be used by anything except the
> kmalloc internals.  No client code should ever use the constant for
> anything.

Yes, I'm aware of this (I should snip less) but I still feel it's not a good 
name. When I read say "a 64-bit pointer" I immediately take that to mean a 
pointer of size 64-bit, not a pointer to 64-bits and only it not making any 
sense would stop me from interpreting "ZERO_SIZE_PTR" similarly.

Yes, it's internal but given that this is open-source which, optimistically, is 
read many more times than it's written one should still strive for code that 
reads nice as far as I'm concerned. It's obviously also not hugely important but 
it's just that ZERO_SIZE_PTR makes my neck hair stand up.

Rene.

