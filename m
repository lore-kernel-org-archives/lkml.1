Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbYAKQGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbYAKQGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbYAKQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:06:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759691AbYAKQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:06:40 -0500
Date: Fri, 11 Jan 2008 11:06:22 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080111110622.52604fdc@bree.surriel.com>
In-Reply-To: <1200066610.5304.11.camel@localhost>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1200066610.5304.11.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 10:50:09 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Again, my doing.  I agree that the calculation is a bit strange, but I
> wanted to "future-proof" this function in case we ever get to a value of
> '6' for the lru_list enum.  In that case, the AND will evaluate to
> non-zero for what may not be a file LRU.  Between the build time
> assertion and the division [which could just be a 'l >> 1', I suppose]
> we should be safe.

Good point.  I did not guess that.

I'll restore the code to your original test.

-- 
All rights reversed.
