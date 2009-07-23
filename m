Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbZGWEVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbZGWEVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 00:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZGWEVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 00:21:38 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:58764 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZGWEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 00:21:37 -0400
X-Greylist: delayed 2016 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2009 00:21:37 EDT
Message-ID: <4A67DD16.1090704@cs.columbia.edu>
Date: Wed, 22 Jul 2009 23:46:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Oren Laadan <orenl@librato.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC v17][PATCH 52/60] c/r: support semaphore sysv-ipc
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-53-git-send-email-orenl@librato.com> <20090722172502.GA15805@lenovo>
In-Reply-To: <20090722172502.GA15805@lenovo>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cyrill Gorcunov wrote:
> [Oren Laadan - Wed, Jul 22, 2009 at 06:00:14AM -0400]
> ...
> | +static struct sem *restore_sem_array(struct ckpt_ctx *ctx, int nsems)
> | +{
> | +	struct sem *sma;
> | +	int i, ret;
> | +
> | +	sma = kmalloc(nsems * sizeof(*sma), GFP_KERNEL);
> 
> Forgot to
> 
> 	if (!sma)
> 		return -ENOMEM;
> 
> right?

Yep !  thanks...  (fixed commit to branch ckpt-v17-dev)

Oren.


