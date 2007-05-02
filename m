Return-Path: <linux-kernel-owner+w=401wt.eu-S2992911AbXEBIrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992911AbXEBIrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992916AbXEBIrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:47:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44426 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992908AbXEBIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:47:13 -0400
Date: Wed, 2 May 2007 01:46:17 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       William Irwin <bill.irwin@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Message-ID: <20070502084617.GY26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
	Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
	Ingo Molnar <mingo@elte.hu>
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <20070502005140.b94500ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502005140.b94500ff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:51:40AM -0700, Andrew Morton wrote:
> Thanks for the report.  I can reproduce it.
> Bisection shows that x86_64-mm-paravirt-initial-pagetable.patch caused
> this.
> I didn't check whether the patch actually permits us to read kernel
> memory.  Probably it does.  Probably we'd prefer that it didn't ;)

Brown paper bag time. I don't know how it got past me.


-- wli
