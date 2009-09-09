Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZIIUrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZIIUrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZIIUri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:47:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbZIIUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:47:38 -0400
Date: Wed, 9 Sep 2009 13:46:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, jpirko@redhat.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Message-Id: <20090909134643.5479b09e.akpm@linux-foundation.org>
In-Reply-To: <20090907115430.6C16.A69D9226@jp.fujitsu.com>
References: <20090617132118.ef839ad7.akpm@linux-foundation.org>
	<20090618095705.99D2.A69D9226@jp.fujitsu.com>
	<20090907115430.6C16.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Sep 2009 11:58:36 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Grr, my fault.
> > I recognize it. sorry.
> 
> I've finished my long pending homework ;)
> 
> Andrew, can you please replace following patch with getrusage-fill-ru_maxrss-value.patch
> and getrusage-fill-ru_maxrss-value-update.patch?
> 
> 
> 
> ChangeLog
>  ===============================
>   o Merge getrusage-fill-ru_maxrss-value.patch and getrusage-fill-ru_maxrss-value-update.patch
>   o rewrote test programs (older version hit FreeBSD bug and it obfuscate testcase intention, thanks Hugh)

The code changes are unaltered, so I merely updated the changelog.

The changelog had lots of ^------- lines in it.  But those are
conventionally the end-of-changelog separator so I rewrote them to
^=======

