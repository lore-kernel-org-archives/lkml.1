Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZEKMQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZEKMQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZEKMQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:16:18 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34267 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbZEKMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:16:17 -0400
Date: Mon, 11 May 2009 17:46:12 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 02/12] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090511121612.GC26721@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115240.GC25673@in.ibm.com> <344eb09a0905110512h4f4c98d0oa207e12d88f69e87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <344eb09a0905110512h4f4c98d0oa207e12d88f69e87@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 05:42:22PM +0530, Bharata B Rao wrote:
> On Mon, May 11, 2009 at 5:22 PM, K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > Index: kernel/hw_breakpoint.c
> > ===================================================================
> > --- /dev/null
> > +++ kernel/hw_breakpoint.c
> > @@ -0,0 +1,367 @@
> > +/*
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) 2007 Alan Stern
> > + * Copyright (C) IBM Corporation, 2009
> > + */
> > +
> > +/*
> > + * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
> > + * using the CPU's debug registers.
> > + *
> > + * This file contains the arch-independent routines.  It is not meant
> > + * to be compiled as a standalone source file; rather it should be
> > + * #include'd by the arch-specific implementation.
> 
> That's no longer true, right ?
> 
> Regards,
> Bharata.

Correct. The comments are stale and should have been cleaned-up. I will
do the same during the next submission of the patchset.

Thanks,
K.Prasad

