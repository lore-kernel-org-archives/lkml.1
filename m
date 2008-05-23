Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYEWRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYEWRGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYEWRGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:06:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYEWRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:06:14 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel image
From: David Woodhouse <dwmw2@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Haroldo Gamal <gamal@alternex.com.br>,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <4836F68D.4090603@keyaccess.nl>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <20080523162101.GA31107@uranus.ravnborg.org>
	 <20080523163841.GC27128@csclub.uwaterloo.ca>
	 <20080523164447.GB31545@uranus.ravnborg.org>
	 <4836F68D.4090603@keyaccess.nl>
Content-Type: text/plain
Date: Fri, 23 May 2008 18:06:05 +0100
Message-Id: <1211562365.28967.46.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 18:53 +0200, Rene Herman wrote:
> On 23-05-08 18:44, Sam Ravnborg wrote:
> 
> > On Fri, May 23, 2008 at 12:38:41PM -0400, Lennart Sorensen wrote:
> >> On Fri, May 23, 2008 at 06:21:01PM +0200, Sam Ravnborg wrote:
> >>> Looks good.
> >>> But do we need the firmware after init?
> >>> In other owrds could it be inside a discard after init block?
> >> What is you can hotplug the device and hence need to initialize the same
> >> device type multiple times?  Wouldn't keeping the firmware around be
> >> useful then?  How about on suspend/resume, do you need to reload
> >> firmware in those cases?
> > 
> > There are cases where we need it after init.
> > But if there are cases where we do not need it after init maybe
> > we should be able to save some memory there?
> > 
> > Let us get it working as is - then we can add such features later.
> 
> If embedded is the main consumer I would consider this a fairly vital 
> feature though.

Remember, for now this is mostly just replacing the cases where the
firmware used to be unconditionally present in the kernel. If you really
want to avoid taking kernel memory, put it in userspace.

-- 
dwmw2

