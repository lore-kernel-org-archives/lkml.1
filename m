Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbXKYU3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbXKYU3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbXKYU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:29:42 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:21121 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbXKYU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:29:40 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
X-Message-Flag: Warning: May contain useful information
References: <20071122343.446909000@suse.de>
	<200711221456.22297.rusty@rustcorp.com.au>
	<200711221246.23994.ak@suse.de>
	<200711231129.25982.rusty@rustcorp.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Nov 2007 12:29:39 -0800
In-Reply-To: <200711231129.25982.rusty@rustcorp.com.au> (Rusty Russell's message of "Fri, 23 Nov 2007 11:29:25 +1100")
Message-ID: <adaprxyrrv0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Nov 2007 20:29:40.0026 (UTC) FILETIME=[E78089A0:01C82FA1]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yes, and if a symbol is already used by multiple modules, it's generically 
 > useful.  And if so, why restrict it to in-tree modules?

I agree that we shouldn't make things too hard for out-of-tree
modules, but I disagree with your first statement: there clearly is a
large class of symbols that are used by multiple modules but which are
not generically useful -- they are only useful by a certain small class
of modules.

 - R.
