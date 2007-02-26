Return-Path: <linux-kernel-owner+w=401wt.eu-S1030292AbXBZPO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292AbXBZPO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXBZPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:14:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43985 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXBZPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:14:57 -0500
Date: Mon, 26 Feb 2007 20:44:42 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070226151442.GA29869@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702261139.59130.rjw@sisk.pl> <200702261147.12274.rjw@sisk.pl> <20070226120043.GB234@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226120043.GB234@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 03:00:43PM +0300, Oleg Nesterov wrote:
> In that case we should also modify ____call_usermodehelper(), otherwise we have
> the same "deadlock" if it is frozen. But this is not so easy to do as I thought
> before.

Before ____call_usermodehelper can freeze, it should have entered userspace 
right? By that time, its vfork parent should have definitely woken up,
which should avoid the deadlock you point out?

-- 
Regards,
vatsa
