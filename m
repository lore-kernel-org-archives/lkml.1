Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXGKTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXGKTgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933496AbXGKT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:27:31 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:58432 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbXGKT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:27:30 -0400
In-Reply-To: <1184097931.3020.73.camel@localhost.localdomain>
Subject: Re: [PATCH] fix idr_get_new_above id alias bugs
To: jim.houston@ccur.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linuxppc-dev-bounces+hnguyen=de.ibm.com@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF79FB2152.6DE55EBA-ONC1257315.006AAB0A-C1257315.006AE01D@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Wed, 11 Jul 2007 21:27:26 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 11/07/2007 21:27:27
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> With this patch, idr.c should work as advertised allocating id
> values in the range 0...0x7fffffff.  Andrew had speculated that
> it should allow the full range 0...0xffffffff to be used.  I was
> tempted to make changes to allow this, but it would require changes
> to API, e.g. making the starting id value and the return value
> unsigned.
Hi Jim, thanks much for this patch. It should work fine as far
as I can read. Will give it a try in next couple of days.
Nam

