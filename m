Return-Path: <linux-kernel-owner+w=401wt.eu-S935270AbZJOSoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270AbZJOSoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935248AbZJOSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:44:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55850 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935139AbZJOSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:03 -0400
Date: Thu, 15 Oct 2009 19:44:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>, david@lang.hm,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091015194434.5b8cef42@lxorguk.ukuu.org.uk>
In-Reply-To: <200910151942.40259.bzolnier@gmail.com>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
	<alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm>
	<20091015164726.GA10125@suse.de>
	<200910151942.40259.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 19:42:40 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Thursday 15 October 2009 18:47:26 Greg KH wrote:
> > On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > > however, what I think I saw proposed was to move drivers that need to be 
> > > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> > 
> > What is "proposed" is the following:
> > 
> > 	- For drivers currently in the kernel tree, that the subsystem
> > 	  maintainer, for whatever reason, feels is obsolete / broken /
> > 	  needs major cleaning / wants to get rid of, can be submitted
> > 	  to the staging maintainer to be moved to the drivers/staging/
> > 	  directory.
> 
> This is insanity and opens a door for various forms of abuse.

It seems very sensible to me. It could be abused but that overlooks the
fact that Greg administers staging, the kernel community sees everything
and even if Greg doesn't keep things in order Linus would.

There are a pile of serial drivers that I think should get this
treatement (actually I was simply going to submit removal patches for
rio, riscom8, esp and a couple of others until this idea occurred)
