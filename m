Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYANTY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYANTY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYANTYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:24:18 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4172 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYANTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:24:18 -0500
Date: Mon, 14 Jan 2008 19:25:07 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: EXPORTS_SYMBOLs that are in assembly?
Message-ID: <20080114192507.GC25058@shadowen.org>
References: <Pine.LNX.4.58.0801132038410.1764@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801132038410.1764@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 08:41:20PM -0500, Steven Rostedt wrote:
> 
> Hi guys,
> 
> Just wondering what the proper way to export a symbol that is defined in
> assembly? Or is there some kind of annotation I can add in comment form
> that will let checkpatch know the variable is not in C?
> 
> Here's what I'm getting:
> 
> ./scripts/checkpatch.pl patches/`quilt top`
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its
> function/variable
> #197: FILE: lib/tracing/mcount.c:42:
> +EXPORT_SYMBOL_GPL(mcount);
> 
> total: 0 errors, 1 warnings, 316 lines checked

Could you send me a fuller example fragment defining 'foo' as an
example?  It is entirly possible you are doing it right and this is an
'ignore checkpatch' situation.

-apw
