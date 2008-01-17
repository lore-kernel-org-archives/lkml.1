Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYAQREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYAQREv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYAQREm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:04:42 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:39649 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYAQREl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:04:41 -0500
Date: Thu, 17 Jan 2008 17:05:33 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Make checkpatch.pl's quiet option not print the summary on no errors
Message-ID: <20080117170533.GA1072@shadowen.org>
References: <477C3252.1080001@linux.intel.com> <20080115201054.GC21511@shadowen.org> <20080116110646.GA18366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116110646.GA18366@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 12:06:46PM +0100, Ingo Molnar wrote:
> 
> btw, just found a checkpatch.pl buglet, it gets confused on zero-sized 
> files:
> 
>  $ echo -n > /tmp/1.c
>  $ scripts/checkpatch.pl --file /tmp/1.c
>  ERROR: Does not appear to be a unified-diff format patch
> 
>  total: 1 errors, 0 warnings, 0 lines checked
> 
>  Your patch has style problems, please review.  If any of these errors
>  are false positives report them to the maintainer, see
>  CHECKPATCH in MAINTAINERS.
> 
> (this broke my code-quality scriptlet)

Sigh ... :)

Thanks I'll sort that out.

-apw
