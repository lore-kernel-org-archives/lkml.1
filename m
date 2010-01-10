Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797Ab0AJAkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0AJAkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 19:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440Ab0AJAkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 19:40:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:35648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0AJAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 19:40:03 -0500
Date: Sat, 9 Jan 2010 16:42:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Alex Chiang <achiang@hp.com>, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100109164240.43b21247@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 02:32:11 +0200 (EET)
Dimitrios Apostolou <jimis@gmx.net> wrote:

> On Sat, 9 Jan 2010, Arjan van de Ven wrote:
> 
> > On Sun, 10 Jan 2010 01:55:42 +0200 (EET)
> > Dimitrios Apostolou <jimis@gmx.net> wrote:
> >
> >> L8400B series Notebook PC
> >
> > can you try this patch?
> >
> 
> OK I'm compiling a new kernel right now but that will take a while, I
> only have access to old hardware at the moment... What exactly this
> patch does?
> 

basically it appears that your machine, when the kernel asks for C2,
exits C2 immediately again.

The old algorithm somehow caught this and stopped asking for C2 most of
the time; the new algorithm doesn't see any activity and asks for C2
again.

What the patch does is tell the kernel to just not use C2 at all...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
