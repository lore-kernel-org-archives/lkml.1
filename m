Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXIZJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXIZJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbXIZJEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:04:22 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:14187 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXIZJEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:04:21 -0400
In-Reply-To: <200709251629.52376.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] ibmebus: Remove bus match/probe/remove functions
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF75EB1622.74703D5A-ONC1257362.003152BE-C1257362.0031D489@de.ibm.com>
Date: Wed, 26 Sep 2007 11:04:16 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 26/09/2007 11:04:17,
	Serialize complete at 26/09/2007 11:04:17
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote on 25.09.2007 16:29:51:

> The description makes it sound like a git-bisect would get broken
> by this patch, which should never happen. If the patch indeed
> ends up with a broken kernel, it would be better to merge it with
> the later patch that fixes the code again.

I took extra care to prevent just that from happening. ibmebus will simply 
be disabled during the transition (because of {un,}register_driver being 
empty dummies), but the kernel builds and boots without problems. So 
unless you're trying to find an ibmebus-based problem, git bisect will be 
fine. I'll repost 2/5 with an updated description.

I split the ibmebus rework into three patches because the merged patch was 
impossible to read. Makes reviewing easier.

Joachim
