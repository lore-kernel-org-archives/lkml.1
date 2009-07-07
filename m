Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZGGEFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZGGEFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZGGEFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:05:00 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:52749 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZGGEE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=v79n7BUWlyp+wY+AVL6Ofq9jgTSN6hYS34QJsssgsyiu9HBgFxiIbHYOCfFxu2+cNw
         H/hTHKVVg5lKoOToCWnY3uyK/g9om6O5ac7rzC7wqxayjnWWuopa0EHTbdKN4X8uf18u
         ZqjY2WpURg8503RIgUkzBEMsTpqCjLWcxuQqo=
Date: Tue, 7 Jul 2009 13:04:50 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "MinChan Kim" <minchan.kim@gmail.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #13665] commit 69c854817566 causes OOMs
Message-Id: <20090707130450.cb14f7b9.minchan.kim@barrios-desktop>
In-Reply-To: <dWkuWjWDsSB.A.U7E.g0oUKB@chimera>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	<dWkuWjWDsSB.A.U7E.g0oUKB@chimera>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Jul 2009 02:01:03 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 

It should be listed.

I think it is caused by forking process bomb by msgctl11 on LTP. 
We can refer old discussion(http://osdir.com/ml/linux-kernel/2009-07/msg00926.html)

I think this issue can be solved by 
dynamic reclaim throttling patch which is making by Rik.

After he merges it, Let's test again. 

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
> Subject		: commit 69c854817566 causes OOMs
> Submitter	: David Howells <dhowells@redhat.com>
> Date		: 2009-06-27 08:12 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69c854817566db82c362797b4a6521d0b00fe1d8
> References	: http://lkml.org/lkml/2009/6/27/28
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> Patch		: http://patchwork.kernel.org/patch/32740/
> 
> 


-- 
Kind regards,
Minchan Kim
