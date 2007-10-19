Return-Path: <linux-kernel-owner+w=401wt.eu-S966210AbXJSHF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966210AbXJSHF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXJSHFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:05:20 -0400
Received: from www.tglx.de ([62.245.132.106]:56500 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbXJSHFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:05:18 -0400
Date: Fri, 19 Oct 2007 09:02:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Snook <csnook@redhat.com>
cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mostly merge types.h
In-Reply-To: <20071019060929.GA16291@shell.boston.redhat.com>
Message-ID: <alpine.LFD.0.9999.0710190901310.22770@localhost.localdomain>
References: <20071019060929.GA16291@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Most of types_32.h and types_64.h are the same.  Merge the common definitions
> into types.h, keeping the differences in their own files.  Also #error if
> types_{32,64}.h is included directly.  Tested with allmodconfig on x86_64.

Sorry, your patch is late:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9d256ff51c174d8b157d99db038a1045f37a17c8

And we really want to eliminate the _32/64 variants completely when
ever it is possible.

Thanks,

	tglx
