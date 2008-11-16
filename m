Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYKPQjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYKPQjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYKPQja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:39:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYKPQj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:39:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [patch] ACPI toshiba: only register rfkill if bt is enabled
Date: Sun, 16 Nov 2008 17:44:31 +0100
User-Agent: KMail/1.9.9
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       philipl@overt.org
References: <20081029081934.GB26314@gambetta> <200811161340.36798.rjw@sisk.pl> <200811161550.49957.arvidjaar@mail.ru>
In-Reply-To: <200811161550.49957.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161744.31777.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of November 2008, Andrey Borzenkov wrote:
> On Sunday 16 November 2008, Rafael J. Wysocki wrote:
> > On Sunday, 16 of November 2008, Andrey Borzenkov wrote:
> > > On Wednesday 29 October 2008, Frederik Deweerdt wrote:
> > > > [resending as it didn't make it to the list, removing netdev from cc
> > > > also]
> > > > Hello  Andrey,
> > > > 
> > > > It looks like a part of the rfkill initialization was done whenever
> > > > BT was on or not. The following patch checks for BT presence before
> > > > registering the rfkill to the input layer. Does it solve the problem for
> > > > you?
> > > > 
> > > 
> > > This patch fixes regression in 2.6.28. Patch has been tested and
> > > acnowledged. Rafael, could you add it to list of open regressions?
> > > Thank you!
> > 
> > I will, if you provide me with a link to the patch and (optionally) to the
> > original bug report.
> > 
> 
> Original bug report:
> http://marc.info/?l=linux-kernel&m=122522113619025&w=2
> 
> Patch:
> http://marc.info/?l=linux-kernel&m=122526843117478&w=2

Thanks, added to the list as http://bugzilla.kernel.org/show_bug.cgi?id=12047

Best,
Rafael
