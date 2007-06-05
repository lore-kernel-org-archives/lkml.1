Return-Path: <linux-kernel-owner+w=401wt.eu-S1764947AbXFEOfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764947AbXFEOfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764492AbXFEOfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:35:12 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48500 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763417AbXFEOfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:35:11 -0400
Message-ID: <466573E0.8050809@gmail.com>
Date: Tue, 05 Jun 2007 16:32:00 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com> <alpine.DEB.0.99.0706050951210.30666@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.99.0706050951210.30666@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2007 03:58 PM, John Anthony Kazos Jr. wrote:

> So "ZERO_SIZE_OBJ_PTR" is the most correct form, and "ZERO_SIZE_PTR" is a
> convenient shortening. "ZERO_PTR" is too short and also confuses with NULL
> because NULL is a zero-value object, rather than a non-zero--value pointer to
> a zero-size object.

Like I said, I would prefer NIL of if absolutely need be NIL_PTR. NULL is a 
pointer that doesn't point anywhere valid -- NIL is a pointer that points to a 
zero sized object.

If I'd have a few small children around I'd show them the word ZERO_SIZE_PTR and 
make pictures of them bursting out in tears.

Rene.

