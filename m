Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXCYKDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXCYKDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXCYKDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:03:53 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:60493 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbXCYKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:03:52 -0400
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 12:03:14 +0200
Message-Id: <1174816995.5149.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-24 at 22:55 +0100, Miklos Szeredi wrote:
> This is a slightly different take on the fix for the deadlock in fuse
> with dirty balancing.  David Chinner convinced me, that per-bdi
> counters are too expensive, and that it's not worth trying to account
> the number of pages under writeback, as they will be limited by the
> queue anyway.
> 

Please have a look at this:
  http://lkml.org/lkml/2007/3/19/220


