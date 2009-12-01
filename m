Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZLAKA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZLAKA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZLAKAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZLAKAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:00:24 -0500
Date: Tue, 1 Dec 2009 10:59:47 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091201095947.GM30235@random.random>
References: <20091201181633.5C31.A69D9226@jp.fujitsu.com>
 <20091201093738.GL30235@random.random>
 <20091201184535.5C37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201184535.5C37.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 06:46:06PM +0900, KOSAKI Motohiro wrote:
> Ah, well. please wait a bit. I'm under reviewing Larry's patch. I don't
> dislike your idea. last mail only pointed out implementation thing.

Yep thanks for pointing it out. It's an implementation thing I don't
like. The VM should not ever touch ptes when there's light VM pressure
and plenty of unmapped clean cache available, but I'm ok if others
disagree and want to keep it that way.
