Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbZDHRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbZDHRaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934320AbZDHR3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:29:51 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:61423 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934652AbZDHR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:29:50 -0400
X-IronPort-AV: E=Sophos;i="4.39,345,1235952000"; 
   d="scan'208";a="152580611"
From: Roland Dreier <rdreier@cisco.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
References: <20090407509.382219156@firstfloor.org>
	<20090407221542.91cd3c42.akpm@linux-foundation.org>
	<20090408061539.GD17934@one.firstfloor.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Apr 2009 10:29:34 -0700
In-Reply-To: <20090408061539.GD17934@one.firstfloor.org> (Andi Kleen's message
	of "Wed, 8 Apr 2009 08:15:39 +0200")
Message-ID: <adafxgj6old.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2009 17:29:34.0503 (UTC) FILETIME=[95739370:01C9B86F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > [1] I didn't consider that one high priority since production
 > systems with long uptime shouldn't have much free memory.

Surely there are windows after a big job exits where lots of memory
might be free.  Not sure how big those windows are in practice but it
does seem if a process using 128GB exits then it might take a while
before that memory all gets used again.

 - R.
