Return-Path: <linux-kernel-owner+w=401wt.eu-S1765983AbXGSPFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765983AbXGSPFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXGSPEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:04:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59703 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbXGSPES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:04:18 -0400
Subject: Re: [PATCH for review] [11/48] x86_64: During VM oom condition,
	kill all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707191614180.7377@anakin>
References: <20070719348.540885000@suse.de>
	 <20070719134840.47B5114E6E@wotan.suse.de>
	 <20070719140411.GD16279@infradead.org>
	 <Pine.LNX.4.64.0707191614180.7377@anakin>
Content-Type: text/plain
Organization: IBM
Date: Thu, 19 Jul 2007 10:03:09 -0500
Message-Id: <1184857389.22237.20.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 16:14 +0200, Geert Uytterhoeven wrote:
> On Thu, 19 Jul 2007, Christoph Hellwig wrote:
> > On Thu, Jul 19, 2007 at 03:48:40PM +0200, Andi Kleen wrote:
> > > From: Will Schmidt <will_schmidt@vnet.ibm.com>
> > > 
> > > During a VM oom condition, kill all threads in the process group.
> > > 
> > > We have had complaints where a threaded application is left in a bad state
> > > after one of it's threads is killed when we hit a VM: out_of_memory condition.
> > > 
> > > Killing just one of the process threads can leave the application in a bad
> > > state, whereas killing the entire process group would allow for the
> > > application to restart, or otherwise handled, and makes it very obvious that
> > > something has gone wrong.
> > > 
> > > This change allows the entire process group to be taken down, rather than just
> > > the one thread.
> > 
> > Shouldn't we have one patc hthat does this for every architecture instead
> > of going through arch maintainers and probably losing half of them?
> 
> Yes, please ;-)

Ok, i'm convinced. :-)      I'll spin up an all-arch encompassing patch
in the next day or so. 

-Will



> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> return -EMAINTAINER_TOO_BUSY

