Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbXFLVdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbXFLVdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXFLVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:32:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:54092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbXFLVco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,413,1175497200"; 
   d="scan'208";a="253678817"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: raid5: coding style cleanup / refactor
Date: Tue, 12 Jun 2007 14:32:42 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: raid5: coding style cleanup / refactor
Thread-Index: AcetOD3vh1TqWcUhRliAIhNXk9MKlQAADZDQ
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "NeilBrown" <neilb@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-raid@vger.kernel.org>
X-OriginalArrivalTime: 12 Jun 2007 21:32:43.0149 (UTC) FILETIME=[35D8CBD0:01C7AD39]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Unfortunately these cleanups get into a huge fight with your very own
> git-md-accel.patch:
> 
Yes, you missed the note that said:

	Note, I have not rebased git-md-accel yet.  While that is
happening I
	wanted to have this patch out for review.

> I assume that you're prepared to repair all that damage to your tree,
but
> it seems a bit masochistic?

It's either this or have an inconsistent coding style throughout
raid5.c.  I figure it is worth it to have reduced code duplication
between raid5 and raid6, and it makes it easier to add new cache
features going forward.  I have a few more cleanups to add for a rev2 of
this patch, but I will hold that off until the rebase is done.

Dan
