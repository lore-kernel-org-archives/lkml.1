Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYFBADs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYFBADs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 20:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYFBADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 20:03:38 -0400
Received: from namei.org ([69.55.235.186]:48896 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbYFBADi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 20:03:38 -0400
Date: Mon, 2 Jun 2008 10:02:41 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <48402DAA.60202@linux.intel.com>
Message-ID: <Xine.LNX.4.64.0806020955570.8594@us.intercode.com.au>
References: <48402DAA.60202@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Arjan van de Ven wrote:

> Rank 4: task_has_capability (warning)
> 	Reported 181 times (202 total reports)
> 	[out of tree] Bug in the proprietary firegl driver
> 	warning only shows up in tainted kernels
> 	This warning was last seen in version 2.6.25.3, and first seen in
> 	2.6.25.
> 	More info:
> 	http://www.kerneloops.org/searchweek.php?search=task_has_capability

This is a shining example of why people should avoid binary drivers.  I'd 
guess that the bug is related to the new 64-bit capability code.

It'd be really interesting to know what this driver is doing with 
capabilities in the first place.

If anyone is using this driver, the output of the following command as a 
non-root user from gnome-terminal or similar may be of interest:

$ cat /proc/self/status |grep ^Cap

It should generally be all zeroes.


- James
-- 
James Morris
<jmorris@namei.org>
