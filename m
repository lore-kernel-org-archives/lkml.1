Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbXHQXkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbXHQXkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXHQXka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:40:30 -0400
Received: from www.osadl.org ([213.239.205.134]:49097 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXHQXk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:40:29 -0400
Subject: Re: kfree(0) - ok?
From: Thomas Gleixner <tglx@linutronix.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Satyam Sharma <satyam@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
References: <46C233CB.9000602@am.sony.com>
	 <1187132149.2618.2.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
	 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
	 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
	 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 01:40:22 +0200
Message-Id: <1187394022.7007.133.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-18 at 00:42 +0300, Pekka Enberg wrote:
> On 8/18/07, Christoph Lameter <clameter@sgi.com> wrote:
> > That was merged over my objections. IMHO ksize(NULL) should fail since we
> > are determining the size of an unallocated object.
> 
> Agreed, especially as we have real zero-sized objects returned from
> kmalloc() et al now.

Do we really ? 

If yes, who invented this 1980s reminiscence, where you got valid
pointers for malloc(0) ?

This is completely stupid. You do not go into a bar and order an empty
glass, just because you might eventually become thirsty later.

	tglx


