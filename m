Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZLIRJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZLIRJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZLIRJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:09:21 -0500
Received: from xenotime.net ([72.52.64.118]:37864 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753578AbZLIRJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:09:20 -0500
Date: Wed, 9 Dec 2009 09:09:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: linux-next: Tree for December 9 (hwpoison)
Message-Id: <20091209090921.a3293706.rdunlap@xenotime.net>
In-Reply-To: <20091209174738.3b8c28a6.sfr@canb.auug.org.au>
References: <20091209174738.3b8c28a6.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 17:47:38 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091208:
> 
> 
> The hwpoison tree lost its build failure.


CONFIG_PROC_PAGE_MONITOR is not enabled:


mm/built-in.o: In function `hwpoison_filter':
(.text+0x43cce): undefined reference to `stable_page_flags'

---
~Randy
