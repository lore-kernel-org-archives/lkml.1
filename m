Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbZIRUNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbZIRUNC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZIRUM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:12:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbZIRUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:12:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=M5moPOQwk+gcOMMEZQv+1U+vlkgf2t48QGXUQbZfSG0CYyBMvo/fLnI+wa9DqGuwY
	weCOo/azhiDHv98jvPSzg==
Date: Fri, 18 Sep 2009 13:08:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, rdunlap@xenotime.net, michael@ellerman.id.au,
       ralf@linux-mips.org, wli@holomorphy.com, mel@csn.ul.ie,
       dhowells@redhat.com, arnd@arndb.de, fengguang.wu@intel.com,
       shuber2@gmail.com, hugh.dickins@tiscali.co.uk, zohar@us.ibm.com,
       hugh@veritas.com, mtk.manpages@gmail.com, chris@zankel.net,
       linux-man@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-alpha@vger.kernel.org, linux-mips@linux-mips.org,
       linux-parisc@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/7] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions
In-Reply-To: <08251014d2eb30e9016bab16404133f5c13beacf.1253272709.git.ebmunson@us.ibm.com>
Message-ID: <alpine.DEB.1.00.0909181308110.27556@chino.kir.corp.google.com>
References: <cover.1253272709.git.ebmunson@us.ibm.com> <653aa659fd7970f7428f4eb41fa10693064e4daf.1253272709.git.ebmunson@us.ibm.com> <08251014d2eb30e9016bab16404133f5c13beacf.1253272709.git.ebmunson@us.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Eric B Munson wrote:

> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_HUGETLB
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
