Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbXJETyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbXJETyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXJETyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:54:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXJETyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:54:32 -0400
Date: Fri, 5 Oct 2007 15:54:18 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove throttle_vm_writeout()
Message-ID: <20071005155418.5309e9c3@cuia.boston.redhat.com>
In-Reply-To: <1191569577.22357.22.camel@twins>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	<20071004145640.18ced770.akpm@linux-foundation.org>
	<E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	<20071004160941.e0c0c7e5.akpm@linux-foundation.org>
	<1191569577.22357.22.camel@twins>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 09:32:57 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> I think just adding nr_cpus * ratelimit_pages to the dirth_thresh in
> throttle_vm_writeout() will also solve the problem

Agreed, that should fix the main latency issues.
 
-- 
All Rights Reversed
