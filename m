Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXEGNqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXEGNqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933933AbXEGNqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:46:13 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1137 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbXEGNqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:46:12 -0400
Date: Mon, 7 May 2007 15:46:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeff Garzik <jeff@garzik.org>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
In-Reply-To: <463F27CE.2040008@garzik.org>
Message-ID: <Pine.LNX.4.64.0705071538060.1479@scrub.home>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3y7k1biov.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705070343330.2733@scrub.home> <m3tzupc6wz.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705071318150.1479@scrub.home> <m3r6psc0ee.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705071509290.1479@scrub.home> <463F27CE.2040008@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Jeff Garzik wrote:

> > select seriously screws with the dependencies, it's especially problematic
> > if the selected symbol has other dependencies as HDLC in this case, it makes
> > it only more complicated to get the dependencies correct again.
> > Please use it only if it solves a real problem.
> 
> What he's doing is the standard way to deal with library-style code. Nothing
> wrong with the patch, it's continuing established methods.

select was never meant as autoconfiguration tool. It can't be said often 
enough: select seriously screws with the dependencies, _please_ don't use 
it as a simple depends replacement.
HDLC doesn't really look like simple library code, what's up with all the 
HDLC_* options?

bye, Roman
