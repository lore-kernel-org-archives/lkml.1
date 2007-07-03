Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbXGCWim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbXGCWim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXGCWif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:38:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXGCWif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:38:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 00:46:10 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707032337.52544.rjw@sisk.pl> <20070703213639.GA29149@srcf.ucam.org>
In-Reply-To: <20070703213639.GA29149@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707040046.10856.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 23:36, Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 11:37:51PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 3 July 2007 23:20, Matthew Garrett wrote:
> > > We're used to the idea of applications blocking when a resource they're 
> > > using goes away - NFS has done it forever. 
> > 
> > Now, please tell me how many driver writers even thought that something
> > might try to access their devices after .suspend() had been executed (or
> > even whilie it was being executed)?
> 
> Every single driver that fails under those conditions is already broken, 
> and has been forever. It's likely that they're broken under run-time 
> suspend, too.

Well, I won't argue with that, but do you actually know how many drivers are
broken this way?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
