Return-Path: <linux-kernel-owner+w=401wt.eu-S966055AbXHaRrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966055AbXHaRrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXHaRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:47:05 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:59948 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965619AbXHaRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:47:02 -0400
In-Reply-To: <200708311908.05255.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF9A956FFB.6A9B925D-ONC1257348.006146CE-C1257348.0061ACF6@de.ibm.com>
Date: Fri, 31 Aug 2007 19:46:58 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 31/08/2007 19:47:00,
	Serialize complete at 31/08/2007 19:47:00
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The plaintiff makes a valid point. How about a staging approach: We 
put 
> > the patch as it is now into 2.6.23 so the problem is fixed, and I'll 
post 
> > a "nice" version with autoloading support and a generic of_make_bus_id 

> > function for 2.6.24. Agree?
> 
> Ok, sounds fair. Can you make sure that the resulting bus_id is the same
> for the final version then?

No, it would change once more -- the current, minimal-invasive, variant of 
the fix uses the full_name -> "ehca@12345678", while of_make_bus_id uses 
another format: "12345678.ehca". I don't think this makes much of a 
difference, though, and users shouldn't rely on the bus_id having a 
certain format anyway, so IMHO we can live with this.

Regards,
  Joachim
