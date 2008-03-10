Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYCJWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYCJWLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYCJWLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:11:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:47887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbYCJWLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,476,1199692800"; 
   d="scan'208";a="261778630"
Date: Mon, 10 Mar 2008 15:10:14 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, ego@in.ibm.com, yi.y.yang@intel.com,
       tglx@linutronix.de, akpm@linux-foundation.org, oleg@sign.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keep rd->online and cpu_online_map in sync
Message-ID: <20080310221014.GB27329@linux-os.sc.intel.com>
References: <20080310081425.GA11031@in.ibm.com> <20080310133755.4689.83217.stgit@novell1.haskins.net> <20080310181244.GA27329@linux-os.sc.intel.com> <200803102303.28660.rjw@sisk.pl> <47D5773C.BA47.005A.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D5773C.BA47.005A.0@novell.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 04:00:28PM -0600, Gregory Haskins wrote:
> >>> On Mon, Mar 10, 2008 at  6:03 PM, in message <200803102303.28660.rjw@sisk.pl>,
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote: 
> > On Monday, 10 of March 2008, Suresh Siddha wrote:
> >> >  
> >> > -	case CPU_DOWN_PREPARE:
> >> > +	case CPU_DYING:
> >> 
> >> Don't we need to take care of CPU_DYING_FROZEN aswell?
> > 
> > Well, I'd say we do.
> 
> Should I add that to the patch as well then?

Yes please.
