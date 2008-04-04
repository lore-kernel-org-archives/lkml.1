Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYDDBWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYDDBWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYDDBWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:22:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52296 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYDDBWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:22:43 -0400
Subject: Re: [PATCH 4 of 6] hotplug-memory: use common online_page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F58041.8080204@goop.org>
References: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>
	 <1207270061.943.21.camel@nimitz.home.sr71.net> <47F57CA0.1000500@goop.org>
	 <1207270805.943.33.camel@nimitz.home.sr71.net> <47F58041.8080204@goop.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:22:38 -0700
Message-Id: <1207272158.943.48.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 18:11 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > I guess we could just make the copies conditional on CONFIG_HIGHMEM and
> > define them both next to each other.  It's really a highmem thing more
> > than a per-arch thing.
> 
> Sounds good to me.  On that subject, how different are the various 
> arch_add_memory() functions really?  There seems to be a lot of common 
> stuff in there.

Not to different last I looked.  But, they're small enough (like
online_page()) that we didn't really care.  We waited for someone like
you to come along and care enough to fix it up. :)

-- Dave

