Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXGCS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXGCS0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXGCS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:26:38 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:47780 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbXGCS0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:26:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 20:26:34 +0200
User-Agent: KMail/1.9.7
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031508.45595.rjw@sisk.pl> <200707031709.29968.rjw@sisk.pl>
In-Reply-To: <200707031709.29968.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032026.34649.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Rafael J. Wysocki:
> > > The main reason for deadlocks is because we do a sys_sync() after the
> > > freeze, which we shouldn't do.
> > 
> > So why don't we remove the sys_sync() from freeze_processes() instead?
> 
> The patch follows (untested).

And a further question. The freezer is not atomic. What do you do
if a task not yet frozen calls sys_sync(), but fuse is already frozen?

	Regards
		Oliver
