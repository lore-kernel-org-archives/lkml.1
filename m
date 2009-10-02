Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZJBKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZJBKBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbZJBKBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:01:33 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:59530 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757485AbZJBKBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:01:33 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Fri, 2 Oct 2009 12:01:32 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910021111.55749.elendil@planet.nl> <20091002093226.GJ21906@csn.ul.ie>
In-Reply-To: <20091002093226.GJ21906@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021201.35672.elendil@planet.nl>
X-OriginalArrivalTime: 02 Oct 2009 10:01:35.0782 (UTC) FILETIME=[5399FC60:01CA4347]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Mel Gorman wrote:
> On Fri, Oct 02, 2009 at 11:11:52AM +0200, Frans Pop wrote:
> > My own feeling is that Bartlomiej is correct and that something has
> > changed since .29 and that on average we do have less higher order
> > areas available after the system has been in use for some time, but I
> > can't substantiate that. I do know that before .30 I had never seen
> > the SKB allocation errors.
> >
> > Main problem is that it's hard to deliberately and reproducibly get
> > the system in a state where the errors occur.
>
> Apparently, Karol Lewandowski (cc added) has a reliable
> reproduction case for when the firmware loading problem occurs
> (http://lkml.org/lkml/2009/9/30/242). While it's not the same problem
> exactly, it's probable they're related. I'm hoping the problem commit
> can be identified by his bisection whenever he gets around to it.

That does indeed look like a third independent report for basically the 
same issue.

> [...], I accept that the problem is apparently occuring more now than it
> did so something has changed that is not obvious to normal testing.

Cool, that's progress ;-)
