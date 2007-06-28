Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXF1HKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXF1HKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXF1HKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:10:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:30478 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760209AbXF1HKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F7BIlIoBE4kUIjWXmmAPFS2Kb9HAigOXCt6BGK0d6ZgnFhzEcf7gU346amRkVejJEY7x+7Npc7xECUymSbh+H8thENqmsg3wQNs8YaMxauqayDpm+u4C0Okh2oeS3bXysec8omlOQrYaT8nClTkRoSav5K+b1r4+3MLozrGZLl0=
Message-ID: <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com>
Date: Thu, 28 Jun 2007 07:10:22 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Cc: "Josh Triplett" <josh@kernel.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46835C16.9020700@kernel.org>
	 <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 6/28/07, Li Yang-r58472 <LeoLi@freescale.com> wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Josh Triplett
> > Sent: Thursday, June 28, 2007 2:59 PM
> > To: Jan Engelhardt
> > Cc: dave young; Chris Shoemaker; Josh Triplett;
> linux-kernel@vger.kernel.org;
> > akpm@linux-foundation.org
> > Subject: Re: [PATCH] CodingStyle: Add information about trailing
> whitespace.
> >
> > Jan Engelhardt wrote:
> > > On Jun 28 2007 06:29, dave young wrote:
> > >> IMHO, another  cause of trailing whitespace is human error, for
> > >> example long lines breaking will easy to cause the first line with
> one
> > >> traling whitespace (original space between the last two words).
> > >
> > > Most common errors (to me) are:
> > >
> > >  - hit return+tab too quickly that it interchanges, hence producing
> > >    the unwanted \t\n
> > >  - hit return+return to start a new paragraph of code;
> > >    the intermediate line remains indented if autoindent is on.
> >
> > Interestingly, emacs gets that case right: when you hit enter it
> places the
> > cursor at the properly indented insertion point, but if you leave the
> line
> > without typing anything it does not leave the indentation.  I thought
> I
> > remembered vim doing the same thing, but I just tested and it appears
> not.  It
> > seems to avoid leaving subsequent lines indented, but not the first
> one.
>
> No, vim works just fine here without leaving any indentation.  Maybe the
> version of vim or the options matter.
>
Yes, vim autoindent doesn't leave tabs in blank line for me.
