Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYCKCIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYCKCIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYCKCIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:08:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbYCKCIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:08:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] signals: unify send_sigqueue/send_group_sigqueue completely
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 18:10:25 +0300 <20080308151025.GA25191@tv-sign.ru>
References: <20080308151025.GA25191@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080311020759.B550126F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:07:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine.  But I'd like a comment on the "ret = 1" case making
explicit what that magic return case is for and why the value
matters (to posix_timer_event).


Thanks,
Roland
