Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXJHRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXJHRXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXJHRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:23:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXJHRXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:23:37 -0400
Date: Mon, 8 Oct 2007 13:23:04 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yan Zheng <yanzheng@21cn.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH]fix page release issue in filemap_fault
Message-ID: <20071008132304.7382961d@bree.surriel.com>
In-Reply-To: <1191863723.20745.26.camel@twins>
References: <3d0408630710080828h7ad160dbxf6cbd8513c1ad3e8@mail.gmail.com>
	<1191863723.20745.26.camel@twins>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2007 19:15:23 +0200
Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2007-10-08 at 23:28 +0800, Yan Zheng wrote:
> > Hi all
> > 
> > find_lock_page increases page's usage count, we should decrease it
> > before return VM_FAULT_SIGBUS
> > 
> > Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> 
> Nice catch, .23 material?

An obvious fix for a memory leak.  I think it should go in.

> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
