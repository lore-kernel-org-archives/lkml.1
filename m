Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZBGWkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZBGWkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBGWj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:39:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:7507 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZBGWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wnDoyKy5+k9oKx+11mCCp9KKnujb/Eto55CwtU52pEWtM/CTPYVU52Rs/OdsqgDX31
         cSV10N8IOvLe5y+DEABwHGchGdGNxOGC8UDt/BRo4EtCLz05KVkE/PYFtKQwfPur3wLs
         EDJ8IqFUCxhq1jAAKl9ROk4/SlEQ0IbG9CvVs=
Date: Sun, 8 Feb 2009 01:46:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wixor <wixorpeek@gmail.com>
Cc: JosephChan@via.com.tw, linux-kernel@vger.kernel.org
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
Message-ID: <20090207224601.GA3922@x200.localdomain>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com> <20090207200652.GA3255@x200.localdomain> <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com> <20090207205606.GA3490@x200.localdomain> <c43b2e150902071345r5f1acba2r97231b56044ca38f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43b2e150902071345r5f1acba2r97231b56044ca38f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 10:45:16PM +0100, wixor wrote:
> It was the first one indeed.

Which is 256 MB in size and kernel says it has only 249 MB of vmalloc
space available.

Still strange, kernel should print nastygram when vmalloc space is not
enough.

You can try to boot with vmalloc=260M (261, 262...) option and see what happens.

> vmalloc : 0xf0690000 - 0xfffaa000   ( 249 MB)
