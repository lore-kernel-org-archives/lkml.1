Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbYJRPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbYJRPXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJRPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:23:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2329 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751475AbYJRPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:23:12 -0400
Date: Sat, 18 Oct 2008 11:23:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20081017235838.7BD231544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810181122030.1469-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Roland McGrath wrote:

> > There's another RF-related issue which the patch currently ignores.  
> > Namely, what should happen if a new user breakpoint is registered at
> > the current PC address?  We should force the RF flag to 0 so that the
> > breakpoint will be triggered when execution resumes.  The problem is
> > that it's not easy to tell whether the current PC corresponds to the
> > same linear address as that registered for the breakpoint -- i.e., I
> > don't know how the code should go about translating from virtual
> > addresses to linear addresses.  Would this in fact always be the
> > identity mapping?  Presumably not if we're in VM86 mode.
> 
> Um, punt?  There is the hair in step.c:convert_ip_to_linear, but, bah.

Punting is exactly what the patch does now.  Together with a FIXME 
comment.

Alan Stern

