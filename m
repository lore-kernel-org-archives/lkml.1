Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXCTWV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXCTWV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXCTWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:21:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXCTWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:21:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/5] swsusp: fix error paths in snapshot_open
Date: Tue, 20 Mar 2007 23:24:38 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl> <200703202226.42673.rjw@sisk.pl> <20070320221615.GO3545@elf.ucw.cz>
In-Reply-To: <20070320221615.GO3545@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202324.39213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 23:16, Pavel Machek wrote:
> Hi!
> 
> > We forget to increase device_available if there's an error in
> > snapshot_open(), so the snapshot device cannot be open at all after
> > snapshot_open() has returned an error.
> 
> Actually, this should go to the beggining of series, as it is
> (non-critical) bugfix.

Well, yes.

I've just kept the original order.  OTOH, I don't think it's as urgent as to go
into 2.6.21 ("been there forever" kind of thing).

Rafael
