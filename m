Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZE0UTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZE0UTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbZE0URb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:17:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933516AbZE0UR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:17:26 -0400
Date: Wed, 27 May 2009 13:14:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mingo@elte.hu, stable@kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh.dickins@tiscali.co.uk,
       Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       starlight@binnacle.cx, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
Subject: Re: [PATCH 0/2] Fixes for hugetlbfs-related problems on shared
 memory
Message-Id: <20090527131437.5870e342.akpm@linux-foundation.org>
In-Reply-To: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 12:12:27 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The following two patches are required to fix problems reported by
> starlight@binnacle.cx. The tests cases both involve two processes interacting
> with shared memory segments backed by hugetlbfs.

Thanks.

Both of these address http://bugzilla.kernel.org/show_bug.cgi?id=13302, yes?
I added that info to the changelogs, to close the loop.

Ingo, I'd propose merging both these together rather than routing one
via the x86 tree, OK?

Question is: when?  Are we confident enough to merge it into 2.6.30
now, or should we hold off for 2.6.30.1?  I guess we have a week or
more, and if the changes do break something, we can fix that in
2.6.30.1 ;)


