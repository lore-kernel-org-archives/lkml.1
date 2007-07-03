Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbXGCNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbXGCNCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXGCNCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:02:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbXGCNCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:02:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:09:39 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707030813.53481.oliver@neukum.org> <20070703121313.GA21318@srcf.ucam.org>
In-Reply-To: <20070703121313.GA21318@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031509.39683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 14:13, Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 08:13:53AM +0200, Oliver Neukum wrote:
> 
> > Only if you want to audit all character devices' read() and write()
> > methods for races against suspend().
> > / on fuse is a bad idea.
> 
> Any driver that assumes that userspace will be frozen during suspend has 
> been broken forever. That behaviour has never been guaranteed.

Can we please fix those drivers _first_, then?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
