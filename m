Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXHaOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXHaOfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXHaOe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:34:57 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:53135 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbXHaOe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:34:56 -0400
In-Reply-To: <200708302022.24167.arnd@arndb.de>
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
Message-ID: <OFBB1BA4B6.29175A76-ONC1257348.004DBCB3-C1257348.0050161C@de.ibm.com>
Date: Fri, 31 Aug 2007 16:34:51 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 31/08/2007 16:34:53,
	Serialize complete at 31/08/2007 16:34:53
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd,

> The whole logic of dynamically adding and removing device is rather 
bogus,
> and it prevents autoloading of device drivers. of_platform_make_bus_id
> is the function that is responsible for creating unique names over 
there.

The plaintiff makes a valid point. How about a staging approach: We put 
the patch as it is now into 2.6.23 so the problem is fixed, and I'll post 
a "nice" version with autoloading support and a generic of_make_bus_id 
function for 2.6.24. Agree?

Regards,
  Joachim
