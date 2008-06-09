Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYFIVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYFIVf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYFIVfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:35:12 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:49851 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYFIVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:35:11 -0400
X-IronPort-AV: E=Sophos;i="4.27,614,1204531200"; 
   d="scan'208";a="55058013"
From: Roland Dreier <rdreier@cisco.com>
To: steiner@sgi.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 11/11] GRU Driver - makefile & Kconfig file changes
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080609211047.409885034@attica.americas.sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 14:35:09 -0700
In-Reply-To: <20080609211047.409885034@attica.americas.sgi.com>
	(steiner@sgi.com's message of "Mon, 09 Jun 2008 16:10:39 -0500")
Message-ID: <adaod6a70mq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 21:35:09.0889 (UTC) FILETIME=[B142CB10:01C8CA78]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +EXTRA_CFLAGS += -DDEBUG -Werror -Wall

Not sure if it's appropriate to set these flags for your driver...

 > +	---help---
 > +	This option enables basic support for the SGI UV GRU driver. If
 > +	you are not running on a SGI UV system, say N.

"...enables basic support for the SGI UV GRU."  And it would be a good
idea to include some info about what UV GRU does -- your 0/11
introduction mail had a good description that would be nice to have here
as well.

 - R.
