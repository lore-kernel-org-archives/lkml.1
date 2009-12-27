Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZL0Mnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZL0Mnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZL0Mna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:43:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37555 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZL0Mn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:43:29 -0500
Date: Sun, 27 Dec 2009 13:43:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, cl@linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: lockdep possible recursive lock in slab parent->list->rlock in
	rc2
Message-ID: <20091227124328.GA10661@basil.fritz.box>
References: <20091227120622.GA480@basil.fritz.box> <1261917194.5933.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261917194.5933.2.camel@penberg-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I broke the lockdep annotations in commit
> ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62 ("SLAB: Fix lockdep annotations
> for CPU hotplug"). Does this fix things for you? Heiko, the following
> patch should fix it for you too.

Yes that patch fixes it. Thanks.
-Andi
