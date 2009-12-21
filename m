Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZLUQJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZLUQJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZLUQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:09:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZLUQJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:09:01 -0500
Date: Mon, 21 Dec 2009 18:02:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: BKL use in ptrace
Message-ID: <20091221170237.GA5384@redhat.com>
References: <20091220185318.GA15989@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220185318.GA15989@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Roland)

On 12/20, Andi Kleen wrote:
>
> ptrace has this comment/BKL use:
>
>         /*
>          * This lock_kernel fixes a subtle race with suid exec
>          */
>         lock_kernel();
>
> But unless I'm blind I don't see execve actually getting the BKL
> anywhere. So is this comment outdated or misleading (is the race with exit?)
> or is there a bug?

I never understood this lock_kernel().

In any case it looks outdated. We were going to kill it "soon",
along with other ptrace changes.

Oleg.

