Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbYESUi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbYESUi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYESUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:38:51 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:58779 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbYESUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:38:49 -0400
X-IronPort-AV: E=Sophos;i="4.27,511,1204531200"; 
   d="scan'208";a="69825828"
From: Roland Dreier <rdreier@cisco.com>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
References: <12244.1211204278@vena.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 19 May 2008 13:38:48 -0700
In-Reply-To: <12244.1211204278@vena.lwn.net> (Jonathan Corbet's message of
	"Mon, 19 May 2008 07:37:58 -0600")
Message-ID: <adahccu6nc7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 20:38:49.0045 (UTC) FILETIME=[57723050:01C8B9F0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > If you're sure that this code doesn't need the BKL (and it kind of
 > looked that way to me), the preferred approach seems to be to put in a
 > comment to that effect so that it's clear that the code has been looked
 > at.  So sending me a patch which does this would be great.

OK, will send such a patch after auditing more carefully.  Just to be
very clear, the issue is to make sure the locking is sufficient to
protect against multiple racing open calls to the same character device?

 - R.
