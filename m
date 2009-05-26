Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZEZXje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZEZXje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZEZXj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:39:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZEZXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:39:27 -0400
Date: Tue, 26 May 2009 18:44:36 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090526234436.GB23806@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526193503.GB11909@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> And since you guys showed that just idea of in-kernel checkpointing is not
> rejected outright, it doesn't mean that you can drag every single idea too.

Can you rephrase here?  I have no idea what you mean by 'drag every single
idea'

> Because history shows, that once something (especially user-visible,
> like restart syscall semantics) is in kernel it's nearly impossible
> to cut it out, so it's very-very important to get it right from the very
> beginning.

Absolutely agree (at least in terms of the API for sys_restart() and
sys_checkpoint(), not for inane other stuff like whether there is a
CKPT_OBJ_RESTART_BLOCK).  That is why 6 months ago we were trying to
get to an agreement with Andrey Mirkin about a precise API that would
definately suit both approaches (in-kernel and userspace task recreation
at sys_restart).  That way the basics could go upstream and the rest
could get settled later as we see the fallout from either decision.

-serge
