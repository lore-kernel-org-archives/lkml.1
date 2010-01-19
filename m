Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255Ab0ASAkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0ASAkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330Ab0ASAkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:40:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40682 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab0ASAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:40:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Jan 2010 09:37:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Message-Id: <20100119093719.fb7d32b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FA@shzsmsx501.ccr.corp.intel.com>
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>
	<87bpgurz00.fsf@devron.myhome.or.jp>
	<20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwnrcz.fsf@devron.myhome.or.jp>
	<20100118102544.3e897525.kamezawa.hiroyu@jp.fujitsu.com>
	<87pr58kx9o.fsf@devron.myhome.or.jp>
	<20100118110019.c55ad88a.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwjh3j.fsf@devron.myhome.or.jp>
	<20100118113026.4c6efd26.kamezawa.hiroyu@jp.fujitsu.com>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F6@shzsmsx501.ccr.corp.intel.com>
	<20100118122214.1d13a3e4.kamezawa.hiroyu@jp.fujitsu.com>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FA@shzsmsx501.ccr.corp.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 13:26:44 +0800
"Wu, Fengguang" <fengguang.wu@intel.com> wrote:

> 
> > On error, the kernel returns -EOVERFLOW (via %eax) and libc hides
> > it by
> >  errno = EOVERFLOW
> >  ret = -1
> 
> Ah got it. How about the attached patch?
> 

Seems good to me. Thank you very much.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

