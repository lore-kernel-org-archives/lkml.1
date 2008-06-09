Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYFIVc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYFIVc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYFIVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:32:48 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:38554 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYFIVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:32:48 -0400
X-IronPort-AV: E=Sophos;i="4.27,614,1204531200"; 
   d="scan'208";a="110894291"
From: Roland Dreier <rdreier@cisco.com>
To: steiner@sgi.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 09/11] GRU Driver - /proc interfaces
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080609211046.935659965@attica.americas.sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 14:32:46 -0700
In-Reply-To: <20080609211046.935659965@attica.americas.sgi.com>
	(steiner@sgi.com's message of "Mon, 09 Jun 2008 16:10:37 -0500")
Message-ID: <adaskvm70qp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 21:32:47.0121 (UTC) FILETIME=[5C2A2010:01C8CA78]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This file externalizes some GRU state & statistics to the user using the /proc
 > file system.

We don't put stuff like this in /proc any more.  Depending on how the
data will be used, either debugfs or a bunch of sysfs attributes would
be typical ways to export it.
