Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZG0Q0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZG0Q0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZG0Q0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:26:22 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:54793 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZG0Q0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:26:21 -0400
X-IronPort-AV: E=Sophos;i="4.43,277,1246838400"; 
   d="scan'208";a="189967679"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [Patch RFC 29/37] infiniband: Make user_mad semaphore a real one
References: <20090726081459.455111897@linutronix.de>
	<20090726081557.120760694@linutronix.de>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 27 Jul 2009 09:26:18 -0700
In-Reply-To: <20090726081557.120760694@linutronix.de> (Thomas Gleixner's
	message of "Sun, 26 Jul 2009 08:19:33 -0000")
Message-ID: <adaocr6149h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jul 2009 16:26:19.0032 (UTC) FILETIME=[F89D2980:01CA0ED6]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > -	init_MUTEX(&port->sm_sem);
 > +	semaphore_init(&port->sm_sem);

OK by me -- although I'm not clear what's wrong with using existing
sema_init().
