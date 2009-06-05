Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZFERup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZFERup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZFERui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:50:38 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:20429 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZFERui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:50:38 -0400
X-IronPort-AV: E=Sophos;i="4.41,312,1241395200"; 
   d="scan'208";a="173134651"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
References: <200906051143.06119.lkml@morethan.org> <ada63fawq7y.fsf@cisco.com>
	<200906051240.52615.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 05 Jun 2009 10:50:39 -0700
In-Reply-To: <200906051240.52615.lkml@morethan.org> (Michael S. Zick's message
	of "Fri, 5 Jun 2009 12:40:50 -0500")
Message-ID: <adaoct2vac0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Jun 2009 17:50:39.0799 (UTC) FILETIME=[2395EC70:01C9E606]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I'll stick an "i = something" at the top (NULL?) just to shut up gcc.

you can do uninitialized_var(i) as a zero-overhead way to handle this.
