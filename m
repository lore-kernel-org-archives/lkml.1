Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZGXDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZGXDLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGXDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:11:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58244 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZGXDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:11:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Jul 2009 12:08:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, vda.linux@googlemail.com, mikew@google.com,
       xiyou.wangcong@gmail.com, hpa@zytor.com, bblum@google.com
Subject: Re: [RFC][PATCH] flexible array implementation v4
Message-Id: <20090724120811.a581eea5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A692444.2030303@cn.fujitsu.com>
References: <20090723152647.D9391722@kernel>
	<4A692444.2030303@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 11:02:28 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Dave Hansen wrote:
> > Remaining issues:
> > - How should we deal with out-of-range indexes, especially
> >   in flex_array_get() which returns void*?  ERR_PTR()?
> >   BUG_ON()?  return NULL (current behavior)?
> > - Should care be taken not to allow a flex_array_get() to
> >   an index where no flex_array_put() was done?
> > - Should we decay further than just packing things into the
> >   'base' page?  Should we actually kmalloc() less than a
> >   page at times when it will fit?
> > 
> 
> I sugguest find some candidate users and see how this flex_array
> fits them.
> 
Hmm, can't we rewrite cgroup->tasks file using this ?
I'll try some if I have time.

-Kame


