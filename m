Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYAXHLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYAXHLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYAXHLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:11:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:42636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYAXHLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:11:06 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: ignore spurious faults
Date: Thu, 24 Jan 2008 08:11:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <4797D64D.1060105@goop.org> <p73hch3afbm.fsf@bingen.suse.de> <479837F3.8090905@goop.org>
In-Reply-To: <479837F3.8090905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801240811.20093.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 08:02:11 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >> /*
> >> + * Handle a spurious fault caused by a stale TLB entry.  This allows
> >
> > vmalloc_fault already has nearly the same logic. You should look
> > at sharing the code.
>
> Hm, I see what you mean, but its hard to see how to share much code
> there.  It's a case of "two lines common, one line different" repeated 4
> times or so.

The core common logic is checking if the fault agrees with the page tables.
If not do different things.

-Andi
