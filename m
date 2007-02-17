Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXBQOBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXBQOBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 09:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXBQOBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 09:01:37 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:33789 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030190AbXBQOBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 09:01:37 -0500
Date: Sat, 17 Feb 2007 22:59:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
Message-ID: <20070217135922.GA15373@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy> <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 08:25:07AM -0500, Jaya Kumar wrote:
> On 2/17/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >And, as Andrew suggested last time around, could you perhaps push this
> >fancy new idea into the FB layer so that more drivers can make us of it?
> 
> I would like to do that very much. I have some ideas how it could work
> for devices that support clean partial updates by tracking touched
> pages. But I wonder if it is too early to try to abstract this out.
> James, Geert, what do you think?
> 
This would also provide an interesting hook for setting up chained DMA
for the real framebuffer updates when there's more than a couple of pages
that have been touched, which would also be nice to have. There's more
than a few drivers that could take advantage of that.
