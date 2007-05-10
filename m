Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbXEJVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbXEJVEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbXEJVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:04:25 -0400
Received: from mail.fieldses.org ([66.93.2.214]:48759 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760518AbXEJVEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:04:24 -0400
Date: Thu, 10 May 2007 17:04:21 -0400
To: Doug Chapman <doug.chapman@hp.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>
Subject: Re: post 2.6.21 regression in F_GETLK
Message-ID: <20070510210421.GX13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com> <20070510193050.GQ13719@fieldses.org> <20070510193859.GR13719@fieldses.org> <20070510202313.GV13719@fieldses.org> <1178830865.7247.26.camel@dchapman.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178830865.7247.26.camel@dchapman.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:01:05PM -0400, Doug Chapman wrote:
> You are partly right on the test however note that it is using a start
> and len that are specific to the RDLCK so that should _only_ conflict
> with that lock.  I did notice that the LTP test is taking a new lock on
> the entire file which should be blocked by eithe rthe RDLCK or the WRLCK
> and it doesn't check both, I plan on fixing that once this is resolved.
> 
> But, much more importantly F_GETLK is returning F_UNLCK saying that
> there was no conflict at all.

Argh, OK.  I still can't see the problem yet, then.  What filesystem is
this on?

--b.
