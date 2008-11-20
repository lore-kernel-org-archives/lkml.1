Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYKTLMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYKTLMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYKTLLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:11:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbYKTLLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:11:51 -0500
Date: Thu, 20 Nov 2008 09:11:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 19 (v4l2 warnings)
Message-ID: <20081120091132.1a9e8c5f@pedra.chehab.org>
In-Reply-To: <20081120110253.c0f2e80b.sfr@canb.auug.org.au>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
	<20081119105100.26de5ff0.randy.dunlap@oracle.com>
	<20081120110253.c0f2e80b.sfr@canb.auug.org.au>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008 11:02:53 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Mauro,
> 
> On Wed, 19 Nov 2008 10:51:00 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > On Wed, 19 Nov 2008 17:59:17 +1100 Stephen Rothwell wrote:
> 
> (Randy, I didn't really ...)
> 
> > drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 3 has type 'struct v4l2_fract'
> > drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 4 has type 'struct v4l2_fract'
> > drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type 'int', but argument 5 has type 'struct v4l2_fract'
> 
> Introduced in commit b35e0c6035369de9f3273b6a3fbb1c67f830cf49 "4L/DVB
> (9578): v4l core: add support for enumerating frame sizes and intervals"
> and been there for some time now.
> 
> Mauro, please fix this.

I'll be fixing it today. Thank you and akpm for warning me.
> 


-- 

Cheers,
Mauro
