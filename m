Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZBHBRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZBHBRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 20:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZBHBR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 20:17:28 -0500
Received: from ozlabs.org ([203.10.76.45]:48509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZBHBR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:17:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18830.12961.954870.727816@cargo.ozlabs.ibm.com>
Date: Sun, 8 Feb 2009 12:17:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kerneltop "enhancements"
In-Reply-To: <1234007236.24521.29.camel@marge.simson.net>
References: <1233813650.9044.29.camel@marge.simson.net>
	<1234007236.24521.29.camel@marge.simson.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith writes:

> BTW, how does one convince getopt_long() that an option really really
> doesn't require an argument?  no_argument works for the long version,
> but it insists that an argument is required for the short version
> regardless.

Take out the ":" after the "z" in the string argument to getopt_long.

Paul.
