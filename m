Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXHAIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXHAIEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbXHAIEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:04:13 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:40158 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbXHAIEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:04:10 -0400
Subject: Re: 2.6.23-rc1-mm2
	(vm-dont-run-touch_buffer-during-buffercache-lookups.patch)
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070801004625.46a24a26.akpm@linux-foundation.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <1185953790.6393.20.camel@perkele>
	 <20070801004625.46a24a26.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 04:04:06 -0400
Message-Id: <1185955446.7393.11.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-08 at 00:46 -0700, Andrew Morton wrote:

> Or you could do something more real-worldly like start up OO, firefox and
> friends, then run /etc/cron.daily/everything and see what the
> before-and-after effects are.  The aggregate info we're looking for is
> captured in /proc/meminfo: swapped, Mapped, Cached, Buffers.

IMO it will be harder to come with reproducible numbers, everyone
desktop is different, as their filesystem contents.

Anyway I will cook up something and post it.  It might be useful for
others to understand the updatedb problem.

I intend to try only this specific patch not the full -mm, is there any
other patch I need to apply too?


- Eric


