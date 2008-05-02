Return-Path: <linux-kernel-owner+w=401wt.eu-S965193AbYEBVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbYEBVkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbYEBVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:40:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932092AbYEBVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:40:09 -0400
Date: Fri, 2 May 2008 14:39:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
In-Reply-To: <20080502213146.GD24080@logfs.org>
Message-ID: <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Jörn Engel wrote:
>
> I have a solution for this, but it would require an incompatible change
> to the format.  And right now I have fairly good confidence in the
> format wrt. ensuring correctness.  So the plan is to merge logfs as-is
> (modulo bugfixes, review fallout, etc.) and handle the changes for this
> and other performance problems with compat flags.  And someday rename
> the whole mess to log2fs and remove some support for old format
> variants.

Quite frankly, if that's the case, I'd *much* rather see that worked on 
first, so that there aren't any format changes that are already known to 
be pending before it even gets merged.

Would it be at all possible to try to do that, or is it just "too far 
out"?

		Linus
