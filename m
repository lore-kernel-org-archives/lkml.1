Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYFJOU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYFJOU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYFJOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:20:14 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:18135 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYFJOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:20:12 -0400
X-IronPort-AV: E=Sophos;i="4.27,617,1204531200"; 
   d="scan'208";a="78071260"
From: Roland Dreier <rdreier@cisco.com>
To: Jack Steiner <steiner@sgi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 09/11] GRU Driver - /proc interfaces
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080609211046.935659965@attica.americas.sgi.com>
	<adaskvm70qp.fsf@cisco.com> <20080609221105.GA20211@sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Jun 2008 07:20:10 -0700
In-Reply-To: <20080609221105.GA20211@sgi.com> (Jack Steiner's message of "Mon,
	9 Jun 2008 17:11:06 -0500")
Message-ID: <aday75d5q3p.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jun 2008 14:20:11.0090 (UTC) FILETIME=[1793DB20:01C8CB05]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > AFAICT, this is not a format that is compatible with the /sys guidelines of 1 value
 > per file.
 > 
 > A system can have 1000's of GRU chiplets. Having separate collection of files for
 > each set of metrics is clumsy. What other drivers have similar issues. I'll
 > gladly copy whatever makes sense.

I guess the closest parallel would be networking, where you might have
1000s of routes etc.  So maybe netlink is your best bet.

 - R.
