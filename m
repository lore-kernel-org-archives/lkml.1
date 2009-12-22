Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbZLVKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbZLVKLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZLVKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:11:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZLVKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:11:29 -0500
Date: Tue, 22 Dec 2009 10:11:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, San Mehat <san@google.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched: restore sanity
Message-ID: <20091222101112.GQ18217@ZenIV.linux.org.uk>
References: <1261315437.4314.6.camel@laptop> <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop> <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com> <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com> <1261322387.4314.22.camel@laptop> <1261329743.30458.179.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261329743.30458.179.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 09:22:23AM -0800, Joe Perches wrote:

> pr_<level> offers some things printk cannot:
> 
> o standardization, eliminates frequent missing KERN_ levels
>   and missing/typo/misspelled module prefixes  
> o visually shorter, fewer chars used, less 80 char wrapping
> o finer grained ability to eliminate unnecessary messages
>   for embedded systems
> o standardized mechanism to prefix messages with module/function
> o eventual code reduction via use of a singleton instead of
>   duplicated module/function names
> o eventual dynamic_debug styled control of prefix by
>   module/function

o leveraging the synergy between make-work job and commit count masturbation
