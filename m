Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXDDUus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXDDUus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXDDUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:50:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55986 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXDDUur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:50:47 -0400
Date: Wed, 4 Apr 2007 13:50:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, npiggin@suse.de, hugh@veritas.com,
       linux-mm@kvack.org, tee@sgi.com, holt@sgi.com, andrea@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc] no ZERO_PAGE?
Message-Id: <20070404135030.0683fb49.akpm@linux-foundation.org>
In-Reply-To: <20070404.131111.62667528.davem@davemloft.net>
References: <20070330024048.GG19407@wotan.suse.de>
	<20070404033726.GE18507@wotan.suse.de>
	<Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
	<20070404.131111.62667528.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 13:11:11 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> As I understand the patch being considered to remove ZERO_PAGE(), this
> kind of core dump will cause a lot of pages to be allocated, probably
> eating up a lot of system time as well as memory.

Point.

Also, what effect will the proposed changes have upon rss reporting,
and upon the numbers in /proc/pid/[s]maps?
