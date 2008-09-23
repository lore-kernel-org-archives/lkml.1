Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYIWQXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYIWQXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYIWQW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:22:58 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:36333 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYIWQW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:22:57 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 12:22:57 EDT
From: Gabriel Paubert <paubert@iram.es>
Date: Tue, 23 Sep 2008 17:53:58 +0200
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal -v2
Message-ID: <20080923155358.GA15776@iram.es>
References: <200809221602.32616.srinivasa@in.ibm.com> <20080923112812.GL29021@elte.hu> <20080923113001.GA12531@elte.hu> <200809231955.01564.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231955.01564.srinivasa@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 07:55:01PM +0530, Srinivasa Ds wrote:
> On Tuesday 23 September 2008 17:00:01 Ingo Molnar wrote:
> 
> > > applied to [the new topic] tip/core/signal, thanks Srinivasa! There
> > > are some other pending x86 signal changes already, so i based
> > > tip/core/signal on tip/x86/signal.
> >
> > -tip testing found the following build error with the attached config:
> >
> 
> Ingo, Reproduced build break issue with your config on tip tree. It was a costly overlook 
> to miss one header file. I included it in this patch and tested it out.
> 
> 
> Currently a SIGTRAP can denote any one of below reasons.
> 	- Breakpoint hit
> 	- H/W debug register hit
> 	- Single step
> 	- Signal sent through kill() or rasie()

Typo: s/rasie/raise/

No strong opinion about the patch, but more info is usually better.

	Regards,
	Gabriel
