Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYBKKWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYBKKWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYBKKWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:22:40 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1973 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYBKKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:22:40 -0500
Date: Mon, 11 Feb 2008 10:23:39 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080211102339.GD11671@shadowen.org>
References: <20080210143240.GA13317@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210143240.GA13317@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 03:33:02PM +0100, Marcin Slusarz wrote:
> Hi
> 
> Checkpatch in current mainline outputs following errors:
> 
> $ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #205: FILE: fs/udf/misc.c:205:
> +       tag *tag_p;
>             ^
> 
> $ ./scripts/checkpatch.pl -q --file ./fs/udf/unicode.c
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #48: FILE: fs/udf/unicode.c:48:
> +int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
>                                                ^
> (...)
> 
> I think the code is ok.

Yep the code is clearly correct.  Can I have the whole patch fragment
you got these against so I can figure out why we are unable to detect
these two as types, I would expect us to have done so.  Also what
version of checkpatch is this?  There is a version string at the top.

-apw
