Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbXJVPTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbXJVPTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXJVPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:19:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXJVPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:19:13 -0400
Date: Mon, 22 Oct 2007 11:19:04 -0400
From: Rik van Riel <riel@redhat.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Roel Kluin" <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
Message-ID: <20071022111904.72f54ab9@bree.surriel.com>
In-Reply-To: <84144f020710220230t24d95470o7cabec4450e68814@mail.gmail.com>
References: <471BF741.2020501@tiscali.nl>
	<20071021214209.1a7567d7@bree.surriel.com>
	<84144f020710220230t24d95470o7cabec4450e68814@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 12:30:00 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> On 10/22/07, Rik van Riel <riel@redhat.com> wrote:
> > BUG() will terminate the process that runs into it, so you can
> > just remove the return alltogether.  If BUG() is hit, the return
> > will never be reached.
> 
> This isn't true when CONFIG_BUG is disabled (in embedded builds, for
> example).

*blink*

I guess people who disable CONFIG_BUG really choose to shoot themselves
in the foot when something bad happens.  The kernel is full of error
paths where the current thread really should not be continuing.

Oh well...

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
