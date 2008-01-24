Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYAXRWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYAXRWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYAXRW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:22:28 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54246 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889AbYAXRW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:22:27 -0500
Date: Thu, 24 Jan 2008 12:22:26 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Marcin Gil <marcin.gil@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080124172226.GG16171@csclub.uwaterloo.ca>
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com> <20080124142717.GA16173@csclub.uwaterloo.ca> <4798A114.6010803@gmail.com> <20080124144359.GD16171@csclub.uwaterloo.ca> <4798A537.9000104@gmail.com> <m3abmvtah1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3abmvtah1.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 06:11:22PM +0100, Krzysztof Halasa wrote:
> Marcin Gil <marcin.gil@gmail.com> writes:
> 
> > +-----+-----+
> > mobo  hdd   dvd
> >
> > I think that cable select would take dvd as master and hdd as slave.
> > This was not preferable when hdd was my primary drive. I can try
> > cable-select now since I boot off new SATA drive.
> 
> Is a master in the middle permitted by the specs at all?

On 40 pin cable select it was in fact required.  On 80pin the end is the
master and the middle the slave which I believe is supposed to give
better signal quality when only one device is in use.

--
Len Sorensen
