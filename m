Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZIVLcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZIVLcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZIVLcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:32:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:47520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756164AbZIVLcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:32:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/1PNYauVb12G/IRsVABCukItStFdmg7axVYwpY0U
	dvJ17cFwbX4z8p
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: James Cloos <cloos@jhcloos.com>, lkml <linux-kernel@vger.kernel.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
In-Reply-To: <20090922112246.GA23987@khazad-dum.debian.net>
References: <20090920080728.73bfe2a1@infradead.org>
	 <4AB5ECD0.7010903@datenparkplatz.de>
	 <1253475521.9224.43.camel@marge.simson.net> <4AB6C73C.1030004@gmail.com>
	 <1253507034.23414.90.camel@marge.simson.net>
	 <4AB72FDC.5090403@datenparkplatz.de>
	 <1253520364.25640.57.camel@marge.simson.net>
	 <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
	 <1253603193.6875.118.camel@marge.simson.net>
	 <1253611228.11051.2.camel@marge.simson.net>
	 <20090922112246.GA23987@khazad-dum.debian.net>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 13:32:00 +0200
Message-Id: <1253619120.13917.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 08:22 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 22 Sep 2009, Mike Galbraith wrote:
> > On Tue, 2009-09-22 at 09:06 +0200, Mike Galbraith wrote:
> > > I don't know if distros provide a tool that supports SCHED_IDLE, if so,
> > > you can use that to set both CPU and IO usage to IDLE class in one go.
> > 
> > P.S.  I just remembered, don't use SCHED_IDLE with kernels < 2.6.28.
> > There are two patches wrt this scheduling class which did not go to the
> > stable trees less than 2.6.28.
> 
> Since 2.6.27 is long-term, maybe they should be sent to 2.6.27?  It is weird
> to have a long-term stable kernel for which the recommendation is "don't use
> SCHED_IDLE".

Yeah, that's what I thought too, but apparently maintainers didn't think
SCHED_IDLE was common/important enough.

	-Mike

