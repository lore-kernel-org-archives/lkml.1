Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYCLC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYCLC1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYCLC1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:27:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:20488 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYCLC1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,483,1199692800"; 
   d="scan'208";a="353418540"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200803112318.28120.rjw@sisk.pl>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>  <200803112318.28120.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 10:26:28 +0800
Message-Id: <1205288788.29875.28.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 12 Mar 2008 02:24:12.0508 (UTC) FILETIME=[2916F1C0:01C883E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 23:18 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 11 of March 2008, Vivek Goyal wrote:
[...]
> > Rafael/Pavel, does the approach of doing hibernation using a separate
> > kernel holds promise?
> 
> Well, what can I say?
> 
> I haven't been a big fan of doing hibernation this way since the very beginning
> and I still have the same reservations.  Namely, my opinion is that the
> hibernation-related problems we have are not just solvable this way.  For one
> example, in order to stop using the freezer for suspend/hibernation we first
> need to revamp the suspending/resuming of devices (uder way) and the
> kexec-based approach doesn't help us here.  I wouldn't like to start another
> discussion about it though.

Yes. We need to work on device drivers for all hibernation
implementations. And kexec-based hibernation provides a possible method
to avoid freezer after driver works done.

Best Regards,
Huang Ying

