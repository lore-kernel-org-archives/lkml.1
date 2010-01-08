Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341Ab0AHWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0AHWwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233Ab0AHWwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:52:33 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45377 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0AHWwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:52:32 -0500
Date: Fri, 8 Jan 2010 23:52:31 +0100
From: Andreas Mohr <andi@lisas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100108225231.GA11332@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is, however, a reason *not* to do it which should be carefully
> considered: by co-locating the compatibility version with the modern
> version, it gets access to static functions that are part of the
> implementation of the modern version.  If we move the compatibility
> versions out, it may entail having to export those statics.
> 
>         -hpa

Hmm, do I hear a reason to simply fully #include the (newly separated)
old-style .c file from within the new-style .c file?
Not necessarily a wonderful approach, but perhaps it beats doing a "correct
full separation" and thus having a couple new-born (and unhappy ;) exports
any day?

Andreas Mohr
