Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbXFDSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbXFDSrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXFDSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:47:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbXFDSrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:47:12 -0400
Date: Mon, 4 Jun 2007 11:41:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-Id: <20070604114110.0b88fe7a.akpm@linux-foundation.org>
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2007 10:46:24 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> This version brings a host of changes to cure false positives and
> bugs detected on patches submitted to lkml and -mm.  It also brings
> a number of new tests in response to reviews, of particular note:
> 
>   - catch use of volatile
>   - allow deprecated functions to be listed in feature-removal-schedule.txt
>   - warn about #ifdef's in c files
>   - check that spinlock_t and struct mutex use is commented
>   - report on architecture specific defines being used
>   - report memory barriers without an associated comment

Oy.  I ran checkpatch.pl across this patch and it failed to report upon the
new trailing whitespace which you just tried to add.
