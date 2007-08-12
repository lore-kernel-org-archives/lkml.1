Return-Path: <linux-kernel-owner+w=401wt.eu-S1765898AbXHLD3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765898AbXHLD3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXHLD3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:29:24 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60552 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXHLD3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:29:23 -0400
X-IronPort-AV: i="4.19,249,1183359600"; 
   d="scan'208"; a="198570703:sNHT63054756"
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
X-Message-Flag: Warning: May contain useful information
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
	<46BE621E.9090509@gmail.com>
	<9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
	<46BE7BB6.2010607@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 11 Aug 2007 20:29:21 -0700
In-Reply-To: <46BE7BB6.2010607@gmail.com> (Rene Herman's message of "Sun, 12 Aug 2007 05:17:10 +0200")
Message-ID: <ada4pj5l9bi.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Aug 2007 03:29:22.0079 (UTC) FILETIME=[F96362F0:01C7DC90]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >         /*
 >          * Maximum threshold is 125
 >          */
 >         threshold = min(125, threshold);
 > 
 > as either the comment or the code is wrong and it seems it's the
 > code.

What's the problem?  That line sets threshold to the smaller of the
current value or 125, which is exactly what one would want to do if
the maximum value is 125.  Just do a couple of examples: eg if threshold
is 100 going into that line, then the value is left alone; if
threshold is 150 then it gets set to 125; and that seems exactly correct.

 - R.
