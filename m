Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZEJRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZEJRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZEJRJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 13:09:17 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:41096 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZEJRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 13:09:17 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 10 May 2009 12:09:12 -0500
User-Agent: KMail/1.9.9
References: <200903041828.49972.m.bueker@berlin.de> <200905101753.35282.mb@bu3sch.de> <4A070089.4090804@googlemail.com>
In-Reply-To: <4A070089.4090804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101209.15634.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 10 2009, Michael Riepe wrote:
> 
> Michael Buesch wrote:
> 
> >>It seems to me that this particular chip really doesn't like MSI.
> > 
> > 
> > I can confirm this. I tried with msi enabled and it starts breaking
> > after a few seconds of heavy transfers. Disabling MSI results in a reliable connection.
> > 
> > Maybe we should disable MSI as temporary workaround for affected chips?
> 
> Yep. It may not solve the problem, but it's a lot better than turning
> MSI off for everything, including apparently working NICs that use the
> same driver(s).
> 

Lucky people, at least you have a device specific driver.  ;)
No device specific driver for the Via PCI-to-PCIe bridge (1106:324B)
used in the CX700 chip set.
(and the 8139too driver is not acting up on this machine.)

Not a problem in my case, building without MSI support gives up very little.

Mike
