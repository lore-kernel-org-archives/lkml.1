Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZL3Xl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZL3Xl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZL3Xl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:41:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:49286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZL3Xlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:41:55 -0500
Subject: Re: [PATCH 1/3] x86: record relocation offset
From: James Bottomley <James.Bottomley@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com>
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 17:41:46 -0600
Message-Id: <1262216506.2749.254.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 15:26 -0800, H. Peter Anvin wrote:
> Modules are a completely separate thing - they are linked (not even
> just relocated) at insertion time, so they need to be tracked
> separately.

The reasons I gave was why _text relocation didn't work properly for
systemtap.  The first paragraph was just giving a precis of history
explaining to Arnaldo why he remembered there was a problem with _text
based relocations.

> The statement that a _text-based relocation is insufficient is false.
> The entire x86-32 monolithic kernel is relocated as a unit.  The
> x86-64 kernel, too, is relocated as a unit, but using the page tables,
> which means it always runs at the compile-time-selected virtual
> address.

Confused now ... you just repeated what I said in the second paragraph,
but made it sound like you are disagreeing?

James


