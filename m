Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771Ab0AWJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0AWJWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591Ab0AWJWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:22:12 -0500
Received: from ozlabs.org ([203.10.76.45]:49103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0AWJWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:22:11 -0500
Date: Sat, 23 Jan 2010 20:00:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Replace the extended ASCII copyright char to
 normal ASCII sequence
Message-ID: <20100123090005.GA3897@brick.ozlabs.ibm.com>
References: <20100122102541.GA21430@xhl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122102541.GA21430@xhl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 06:25:41PM +0800, Li Hong wrote:

> A copyright extended ASCII char (0xa9) in kernel/perf_event.c makes my utf-8
> compatible vim think it is a binary file. It is better to either use a utf-8
> sequence 0xc20xa9 or just normal copyright ASCII chars '(C)'.

The trouble is, I've been informed that "(C)" has no legal meaning --
it is not equivalent to the C-in-a-circle copyright symbol.  That's
why I put the extended ASCII character in there.  I wouldn't mind the
utf-8 sequence instead though.

Paul.
