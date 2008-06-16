Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYFPNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYFPNij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYFPNiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:38:03 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54317 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYFPNh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:37:58 -0400
Date: Mon, 16 Jun 2008 16:37:07 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, tzanussi@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080616163707.37846652@linux360.ro>
In-Reply-To: <20080616123003.GC18561@Krystal>
References: <20080613041013.274ccb28@linux360.ro>
	<48521C19.6070001@cs.helsinki.fi>
	<20080613185414.306b4baa@linux360.ro>
	<20080616123003.GC18561@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 08:30:03 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> If you need to "emulate" having many CPUs, Xen is always an option.

I'd rather set up a QEMU environment than rebase this on Xen.
  
> Hrm, sounds like a bad idea... please try getting a test setup
> working, it will save you a gazillion iterations and let you
> stress-test your code.

Check your mailbox, I resubmitted the buffer-only channels along with
hotplug fixes. I couldn't test on my machine all hotplug has to offer,
but hotplug does create the buffers correctly when the kernel goes SMP.
 

	Eduard
