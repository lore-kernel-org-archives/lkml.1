Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbXGCNFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbXGCNFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXGCNFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:05:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbXGCNFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:05:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:12:58 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <1183448224.12649.14.camel@localhost>
In-Reply-To: <1183448224.12649.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031512.59194.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 09:37, Romano Giannetti wrote:
> On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > or alternatively we  could do what we do for suspend to RAM on other
> > platforms (PPC and APM) and just not use the freezer.
> 
> As a data point, I am running with this patch on top of 2.6.21.2 the
> last 3+ weeks, with an average of 5/6 STR cycles a day, and had no
> problems at all. (Sony vaio pcg-fx701). Just normal work, I didn't try
> to stress the thing, but I have quite a few times suspended/resumed over
> a big compile without a glitch.
> 
> What are the risks of this patch supposed to be?

See https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.html

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
