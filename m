Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbYGFV1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbYGFV1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbYGFV13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:27:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:33250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbYGFV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:27:28 -0400
Date: Sun, 6 Jul 2008 14:27:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Kernel oops (bug) in fs/buffers.c:create_empty_buffers
Message-ID: <20080706142726.41cb58f1@infradead.org>
In-Reply-To: <20080706133100.8d8ed269.akpm@linux-foundation.org>
References: <20080706132302.5ca87f4f@infradead.org>
	<20080706133100.8d8ed269.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 13:31:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> isofs has a habit of returning impossible block sizes and the
> 
> 	while ((offset -= size) >= 0) {
> 
> consequently loops zero times and alloc_page_buffers() returns null.
> 
> Someone was having a look at it - maybe Jan?
> 
> I assume that the kernloops.org records link back to the original
> report somewhere but I can't find it?

http://www.kerneloops.org/search.php?search=create_empty_buffers
has two:

http://article.gmane.org/gmane.linux.kernel/696582
http://article.gmane.org/gmane.linux.ide/13658


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
