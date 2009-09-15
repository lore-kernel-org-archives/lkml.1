Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZIOSQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZIOSQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIOSQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:16:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28881 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZIOSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADh3r0qrR7PD/2dsb2JhbADIXYhMAZALBYIkgXM
X-IronPort-AV: E=Sophos;i="4.44,391,1249257600"; 
   d="scan'208";a="389273622"
From: Roland Dreier <rdreier@cisco.com>
To: adi hodos <thefatredguy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suggested addition to epoll interface - epoll_post_notification()
References: <2517f1930909150559p505b583fpf3501a1c7dad6634@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Sep 2009 11:16:49 -0700
In-Reply-To: <2517f1930909150559p505b583fpf3501a1c7dad6634@mail.gmail.com>
	(adi hodos's message of "Tue, 15 Sep 2009 15:59:00 +0300")
Message-ID: <adak500f4z2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Sep 2009 18:16:49.0800 (UTC) FILETIME=[B1839080:01CA3630]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I have been playing with epoll lately and I would like to make a suggestion
 > regarding the epoll interface.
 > It would be nice to have a function to wake up a thread/process that is blocked
 > on an epoll_wait() call and sent it some
 > user defined data in the form of a struct epoll_event parameter ( something
 > similar with PostQueuedCompletionStatus() from Windows ).

You might have a look at eventfd() which creates an fd that can be used
to signal from one thread to another (and which can be waited on with epoll).

 - R.
