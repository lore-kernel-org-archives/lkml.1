Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbZKXVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbZKXVPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbZKXVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:15:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35166 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532AbZKXVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:15:23 -0500
To: Eyal Lotem <eyal.lotem@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Using "page credits" as a solution for common thrashing  scenarios
From: Andi Kleen <andi@firstfloor.org>
References: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
Date: Tue, 24 Nov 2009 22:15:29 +0100
In-Reply-To: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com> (Eyal Lotem's message of "Tue, 17 Nov 2009 22:52:51 +0200")
Message-ID: <87aaybwrny.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eyal Lotem <eyal.lotem@gmail.com> writes:

Replying to an old email.

>   * I think it is wrong for the kernel to evict the 15 pages of the bash,
>     xterm, X server's working set, as an example, in order for a
>     misbehaving process to have 1000015 instead of 1000000 pages in its
>     working set. EVEN if that misbehaving process is accessing its working
>     set far more aggressively.

One problem in practice tends to be that it's hard to realiably detect
that a process is misbehaving. The 1000000 page process might be your
critical database, while the 15 page process is something very
unimportant.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
