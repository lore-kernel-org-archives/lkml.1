Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0BCBRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:17:13 -0500
Received: from perceval.irobotique.be ([92.243.18.41]:41057 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0BCBRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:17:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH V3] drivers/media/video/uvc: Use %pUl to print UUIDs
Date: Wed, 3 Feb 2010 02:18:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1255471594.18975.79.camel@Joe-Laptop.home> <4B684361.2020009@infradead.org> <1265133043.1945.13.camel@Joe-Laptop.home>
In-Reply-To: <1265133043.1945.13.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002030218.20251.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 18:50:43 Joe Perches wrote:
> On Tue, 2010-02-02 at 13:23 -0200, Mauro Carvalho Chehab wrote:
> > I'm reviewing all patches marked as under review at Patchwork and I
> > noticed that this one were never applied, nor I found any nack at
> > linux-media ML.
> >
> > What's the status for it?
> 
> Laurent wanted it withdrawn so he could fix some
> backward compatibility thing he wanted.
> 
> http://lkml.org/lkml/2009/11/4/216
> 
> Nothing's happened since as far as I know.

There's a patch in my git tree, I'll send a pull request tomorrow. I had 
actually prepared a -hg compat patch as well, but the switch to git changed 
the workflow.

Douglas, will you handle the -hg compat "automatically" ? The code will 
compile on older kernels without a warning, but it will still require #ifdef's 
to run correctly on older kernels. Is there a standard way to notify you about 
that during patches submission ?

-- 
Regards,

Laurent Pinchart
