Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXKPBJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXKPBJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbXKPBJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:09:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbXKPBJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:09:43 -0500
Date: Thu, 15 Nov 2007 17:09:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: apw@shadowen.org, linux-kernel@vger.kernel.org, morgan@kernel.org
Subject: Re: 2.6.24-rc2-mm1 -- strange apparent network failures
Message-Id: <20071115170918.ca62ba62.akpm@linux-foundation.org>
In-Reply-To: <200711152101.33266.kjwinchester@gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<200711152028.29734.kjwinchester@gmail.com>
	<20071115164441.67a8e2df.akpm@linux-foundation.org>
	<200711152101.33266.kjwinchester@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 21:01:32 -0400
Kevin Winchester <kjwinchester@gmail.com> wrote:

> On November 15, 2007 08:44:41 pm Andrew Morton wrote:
> > On Thu, 15 Nov 2007 20:28:29 -0400
> >
> > Kevin Winchester <kjwinchester@gmail.com> wrote:
> > > On November 15, 2007 06:02:09 am Andy Whitcroft wrote:
> 
> > > I see this as well - the computer boots fine but no network.  The only
> > > clues in the dmesg are:
> > >
> > > [  294.097876] warning: process `dhclient' gets w/ old libcap
> > > [  294.097893] warning: process `dhclient' sets w/ old libcap
> > >
> > > So I'll try backing up the patch series to before:
> > >
> > > add-64-bit-capability-support-to-the-kernel.patch
> >
> 
> That's the winner.  The changelog indicates that the patch is meant to keep 
> compatibility with older userspace, so I guess it didn't quite keep as much 
> compatibility as it wanted.

OK, thanks for working that out - I'll temporarily drop that patch until we
get it sorted.

