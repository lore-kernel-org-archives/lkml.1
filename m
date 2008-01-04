Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYADRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYADRFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYADRF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:05:27 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32465 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYADRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:05:27 -0500
Subject: Re: [patch 00/19] VM pageout scalability improvements
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric Whitney <eric.whitney@hp.com>,
       Nick Dokos <nicholas.dokos@hp.com>
In-Reply-To: <p73d4sh8s93.fsf@bingen.suse.de>
References: <20080102224144.885671949@redhat.com>
	 <1199379128.5295.21.camel@localhost>
	 <20080103120000.1768f220@cuia.boston.redhat.com>
	 <1199380412.5295.29.camel@localhost>
	 <20080103170035.105d22c8@cuia.boston.redhat.com>
	 <1199463934.5290.20.camel@localhost>  <p73d4sh8s93.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 04 Jan 2008 12:06:12 -0500
Message-Id: <1199466372.5290.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 17:34 +0100, Andi Kleen wrote:
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:
> 
> > We can easily [he says, glibly] reproduce the hang on the anon_vma lock
> 
> Is that a NUMA platform? On non x86? Perhaps you just need queued spinlocks?

We see this on both NUMA and non-NUMA. x86_64 and ia64.  The basic
criteria to reproduce is to be able to run thousands [or low 10s of
thousands] of tasks, continually increasing the number until the system
just goes into reclaim.  Instead of swapping, the system seems to
hang--unresponsive from the console, but with "soft lockup" messages
spitting out every few seconds...


Lee 


> 
> -Andi

