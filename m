Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbYBOMyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbYBOMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYBOMyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:54:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42257 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYBOMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:54:39 -0500
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, jack@suse.cz
In-reply-to: <1203079537.6855.41.camel@twins> (message from Peter Zijlstra on
	Fri, 15 Feb 2008 13:45:37 +0100)
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <1203079537.6855.41.camel@twins>
Message-Id: <E1JQ057-0005Dj-R7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 13:54:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2008-02-15 at 12:43 +0100, Miklos Szeredi wrote:
> 
> >  - strange key repeating (short press of a key results in lots of key
> >    press events) when there's some sort of load (I/O?)  I may have
> >    seen this on non-mm kernels as well, but it's definitely more
> >    noticable in -mm
> 
> Do you have CONFIG_FAIR_GROUP_SCHED enabled?, if so, does disabling it
> make it go away?

Yes, it's enabled.  I'll try disabling, but can't immediately verify
if it's fixed, as this happens relatively rarely.

But to me it doesn't really sound like a scheduling issue.  Rather
something timer or interrupt related.  But I'm very stupid in all
these areas, so...

Thanks,
Miklos
