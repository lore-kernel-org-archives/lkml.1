Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYDDBAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYDDBAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYDDBAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:00:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38730 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYDDBAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:00:13 -0400
Subject: Re: [PATCH 4 of 6] hotplug-memory: use common online_page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F57CA0.1000500@goop.org>
References: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>
	 <1207270061.943.21.camel@nimitz.home.sr71.net>  <47F57CA0.1000500@goop.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:00:05 -0700
Message-Id: <1207270805.943.33.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 17:56 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > This is OK, but I do think the __weak stuff can make it a bit
> > counter-intuitive to track down which version is actually getting used.
> > Are there any people the currently override that __weak?
> >
> > If not, we should probably just kill it.
> 
> Yes, x86-32 has a different implementation.

I guess we could just make the copies conditional on CONFIG_HIGHMEM and
define them both next to each other.  It's really a highmem thing more
than a per-arch thing.

-- Dave

