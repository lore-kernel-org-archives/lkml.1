Return-Path: <linux-kernel-owner+w=401wt.eu-S1030997AbXDXA0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030997AbXDXA0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030988AbXDXA0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:26:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030996AbXDXA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:26:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Morris <jmorris@namei.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Return EPERM not ECHILD on security_task_wait failure
In-Reply-To: James Morris's message of  Monday, 23 April 2007 19:43:15 -0400 <Line.LNX.4.64.0704231940560.5763@d.namei>
X-Shopping-List: (1) Toxic hay
   (2) Sinuous beef
   (3) Methodical expectations
   (4) Insignificant shallow eggs
Message-Id: <20070424002641.5FB061801A4@magilla.sf.frob.com>
Date: Mon, 23 Apr 2007 17:26:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 15 Mar 2007, Roland McGrath wrote:
> 
> > This patch makes do_wait return -EPERM instead of -ECHILD if some
> > children were ruled out solely because security_task_wait failed.
> 
> What about using the return value from the security_task_wait hook (which 
> should be -EACCES) ?

As I said in some earlier discussion following my original patch, that
would be fine with me.  I haven't coded up that variant, but it's simple
enough.  Would you like to do it?


Thanks,
Roland
