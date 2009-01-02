Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZABUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZABUCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbZABUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:02:23 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:5104 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbZABUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:02:22 -0500
X-IronPort-AV: E=Sophos;i="4.36,319,1228089600"; 
   d="scan'208";a="124416939"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb: Add missing __init annotations
References: <adamyedq8p3.fsf@cisco.com>
	<20090101130255.GA21886@uranus.ravnborg.org>
	<20090102192502.GF14249@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 Jan 2009 12:02:19 -0800
In-Reply-To: <20090102192502.GF14249@elte.hu> (Ingo Molnar's message of "Fri,
	2 Jan 2009 20:25:02 +0100")
Message-ID: <adasko1pjck.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jan 2009 20:02:19.0666 (UTC) FILETIME=[04A87720:01C96D15]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -186,7 +186,7 @@ static void swiotlb_print_info(unsigned long bytes)
> >   * Statically reserve bounce buffer space and initialize bounce buffer data
> >   * structures for the software IO TLB used to implement the DMA API.
> >   */
> > -void __init
> > +void __init __weak
> >  swiotlb_init_with_default_size(size_t default_size)
> 
> This change looks unrealted to __init annotation described in the 
> changelog. Was it intentional?

Yes, that was a thinko -- somehow while reading it I saw the __init
without __weak as being missing an annotation.  Should I resend a fixed
patch?

 - R.
