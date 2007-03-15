Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXCOTJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXCOTJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXCOTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:09:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbXCOTI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:08:56 -0400
Date: Thu, 15 Mar 2007 11:07:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, roland@redhat.com,
       mingo@elte.hu, stable@kernel.org, greg@kroah.com
Subject: Re: [PATCH] Fix COMPAT_VDSO regression bug
Message-Id: <20070315110714.a22581b2.akpm@linux-foundation.org>
In-Reply-To: <45F88780.1080507@wldelft.nl>
References: <45F88780.1080507@wldelft.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 15 Mar 2007 00:38:40 +0100 Leroy van Logchem <leroy.vanlogchem@wldelft.nl> wrote:
>     Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
>     This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.
> 
>     Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
>     reported in bug #8040. Reverting the above patch solved the problem.

I think reverting it is probably the right thing to do, unless we can fix it for
real quite promptly.

But nobody will be able to apply this patch - your email client as really gone
to town on it - the results are phenomenally ugly.

And the patch wouldn't have applied to mainline anyway - there have been other changes.
