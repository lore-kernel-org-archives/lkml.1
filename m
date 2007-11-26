Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXKZF61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXKZF61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXKZF6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:58:16 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:59586 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXKZF6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:58:14 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
X-Message-Flag: Warning: May contain useful information
References: <20071122343.446909000@suse.de>
	<200711231129.25982.rusty@rustcorp.com.au> <adaprxyrrv0.fsf@cisco.com>
	<200711261225.44415.rusty@rustcorp.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Nov 2007 21:58:08 -0800
In-Reply-To: <200711261225.44415.rusty@rustcorp.com.au> (Rusty Russell's message of "Mon, 26 Nov 2007 12:25:44 +1100")
Message-ID: <adalk8lsg3z.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Nov 2007 05:58:08.0701 (UTC) FILETIME=[51DB4ED0:01C82FF1]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I agree that we shouldn't make things too hard for out-of-tree
 > > modules, but I disagree with your first statement: there clearly is a
 > > large class of symbols that are used by multiple modules but which are
 > > not generically useful -- they are only useful by a certain small class
 > > of modules.
 > 
 > If it is so clear, you should be able to easily provide examples?

Sure -- Andi's example of symbols required only by TCP congestion
modules; the SCSI internals that Christoph wants to mark; the symbols
exported by my mlx4_core driver (which I admit are currently only used
by the mlx4_ib driver, but which will also be used by at least the
ethernet NIC driver for the same hardware).  I thought this was
already covered repeatedly in the thread and indeed in Andi's code so
there was no need to repeat it...
