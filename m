Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXLZXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXLZXP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 18:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXLZXPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 18:15:16 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:49377 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXLZXPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 18:15:15 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] sleepy linux
Date: Thu, 27 Dec 2007 00:15:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz> <200712262123.37152.oliver@neukum.org> <20071226203258.GE8094@elf.ucw.cz>
In-Reply-To: <20071226203258.GE8094@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712270015.40165.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. Dezember 2007 21:32:58 schrieb Pavel Machek:
> On Wed 2007-12-26 21:23:37, Oliver Neukum wrote:
> > Am Mittwoch, 26. Dezember 2007 21:17:22 schrieb Pavel Machek:

> > > Is there an easy way to tell if all the devices are runtime suspended?
> > 
> > Do you really want to know whether they are suspended or whether they
> > could be suspended?
> 
> If they are suspended.
> 
> My plan is: let the drivers autosuspend on their own. If I see all of
> them are autosuspended, then it looks like great time to put whole
> system into s2ram...

Your calculation of cost/benefit will be wrong. A driver will have timeouts
based on the cost of a suspend/resume cycle of that device only.
You'd have to calculate of keeping the whole system awake against that.

	Regards
		Oliver
