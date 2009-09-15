Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbZIODzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbZIODzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZIODzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:55:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734AbZIODzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:55:33 -0400
Date: Mon, 14 Sep 2009 20:54:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       yanmin_zhang@linux.intel.com, jens.axboe@oracle.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-Id: <20090914205408.578f7f60.akpm@linux-foundation.org>
In-Reply-To: <20090915054259.5282e5ba@infradead.org>
References: <20090915054259.5282e5ba@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 05:42:59 +0200 Arjan van de Ven <arjan@infradead.org> wrote:

> Rather than adding a new governor temporarily, this just puts the fixes
> into the existing menu governor.

Oh, surprised.  I wasn't actually expecting that to happen.

<actually reads his email>

> I don't mind either way, will replace. 

OK.  I'm not particularly strongly opinionated either way.

The timing is awkward.  We could let it sit in Len's tree and
linux-next for a couple of months or we could say what-the-hell and
merge it.

If the latter, your original merge plan sound better ;) But we should
arrange for the new code to default to "on" for test coverage reasons. 
perhaps the original patch did that already?

