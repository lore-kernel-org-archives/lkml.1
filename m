Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXDAWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXDAWBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 18:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965197AbXDAWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 18:01:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbXDAWBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 18:01:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] clean up tsc-based sched_clock
Date: Mon, 2 Apr 2007 00:01:31 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46102723.9050405@goop.org>
In-Reply-To: <46102723.9050405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020001.31349.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007 23:41, Jeremy Fitzhardinge wrote:
> Three cleanups there:
>  - change "instable" -> "unstable"
>  - it's better to use get_cpu_var for getting this cpu's variables
>  - change cycles_2_ns to do the full computation rather than just the
>    tsc->ns scaling.  It's a simpler interface, and it makes the function
>    more generally useful.

Added thanks
-Andi
