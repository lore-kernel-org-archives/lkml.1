Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169Ab0AGVx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0AGVx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132Ab0AGVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:53:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab0AGVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:53:25 -0500
Date: Thu, 7 Jan 2010 13:52:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stefani Seibold <stefani@seibold.net>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] proc: revert to show stack information in
 /proc/{pid}/status
Message-Id: <20100107135246.0849d609.akpm@linux-foundation.org>
In-Reply-To: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 23:12:22 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Thus, this patch revert it.

OK, thanks, I applied the full revert.

We can look at a new and less costly implementation of this feature for
2.6.34 if desired.  In which case, all we have done is to delay the feature
by one release, which is not a big deal.

