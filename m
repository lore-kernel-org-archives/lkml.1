Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZDWUxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZDWUxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZDWUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:53:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbZDWUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:53:33 -0400
Date: Thu, 23 Apr 2009 13:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hartleys@visionengravers.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc.c: fix sparse warning
Message-Id: <20090423135146.89026a2b.akpm@linux-foundation.org>
In-Reply-To: <20090423203557.GY8633@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9239@mi8nycmail19.Mi8.com>
	<20090423132358.2adf4611.akpm@linux-foundation.org>
	<20090423203557.GY8633@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 21:35:57 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Apr 23, 2009 at 01:23:58PM -0700, Andrew Morton wrote:
> > On Fri, 17 Apr 2009 20:55:06 -0400
> > "H Hartley Sweeten" <hartleys@visionengravers.com> wrote:
> > 
> > > Fix sparse warning in mm/vmalloc.c.
> > > 
> > >   warning: symbol 'tmp' shadows an earlier one
> 
> Folks, could we please add to appropriate documentation (SubmittingPatches,
> perhaps) a bit about using descriptive subjects?

If everyone did that, my typing skillz would deteriorate.

> In general, "$TOOL warning in $FILE" says nothing useful.  In this case
> "Get rid of shadowed variable in mm/vmalloc.c:<function>" would be far
> more useful, with "found by sparse" _maybe_ showing up in the commit
> message more or less as a footnote.  Or even "shadowed variable in
> mm/vmalloc.c:<function>".

yup.
