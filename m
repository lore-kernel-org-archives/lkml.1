Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZDWUgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZDWUgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZDWUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:36:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46352 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDWUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:36:00 -0400
Date: Thu, 23 Apr 2009 21:35:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc.c: fix sparse warning
Message-ID: <20090423203557.GY8633@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9239@mi8nycmail19.Mi8.com> <20090423132358.2adf4611.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423132358.2adf4611.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 01:23:58PM -0700, Andrew Morton wrote:
> On Fri, 17 Apr 2009 20:55:06 -0400
> "H Hartley Sweeten" <hartleys@visionengravers.com> wrote:
> 
> > Fix sparse warning in mm/vmalloc.c.
> > 
> >   warning: symbol 'tmp' shadows an earlier one

Folks, could we please add to appropriate documentation (SubmittingPatches,
perhaps) a bit about using descriptive subjects?

In general, "$TOOL warning in $FILE" says nothing useful.  In this case
"Get rid of shadowed variable in mm/vmalloc.c:<function>" would be far
more useful, with "found by sparse" _maybe_ showing up in the commit
message more or less as a footnote.  Or even "shadowed variable in
mm/vmalloc.c:<function>".
