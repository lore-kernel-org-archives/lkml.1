Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbXFEM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbXFEM5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 08:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXFEM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 08:57:15 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:38709 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbXFEM5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 08:57:15 -0400
Message-ID: <46655CEC.7070900@gmail.com>
Date: Tue, 05 Jun 2007 14:54:04 +0200
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
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2007 02:07 PM, John Anthony Kazos Jr. wrote:

> The name says exactly what it is. It's not at all dreadful. If we're going 
> to return a special value in the zero-size case (and in only that case) as 
> a valid pointer instead of actually allocating one byte and treating it as 
> zero, what we have is...a zero-size pointer.

No, what we have is a sizeof(pointer) sized pointer pointing to an object of 
size zero. ZERO_SIZE_PTR is butt-ugly. With a really ugly butt.

Rene.

