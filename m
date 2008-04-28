Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbYD1KaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbYD1KaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbYD1K36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:29:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765725AbYD1K35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:29:57 -0400
Message-ID: <4815A721.1040101@firstfloor.org>
Date: Mon, 28 Apr 2008 12:29:53 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jeff Arnold <jbarnold@MIT.EDU>
CC: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <87r6cvgyi1.fsf@basil.nowhere.org> <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Arnold wrote:

> I'm certainly interested in bringing the code up to kernel coding
> standards (for example, I'd be happy to address any issues with the code
> that are brought to my attention).  I'm not sure whether submitting it
> for mainline makes sense since the software doesn't significantly
> benefit from being bundled with the kernel.

To be honest you weren't the first to come up with something like this
(although you're the first to post to l-k as far as I know). But the
usual problem of something that is kept out of tree is that it
eventually bitrots and gets forgotten. The only sane way to make such
extensions a generically usable linux feature is to merge them to mainline.

> Instead, it might be more important to 1) package the userspace
> update-construction software for common Linux distributions to make it
> easily available to interested users, and 2) to provide binary kernel
> updates for common distribution kernels so that users can simply sign up
> and get fewer "your machine needs to be rebooted now for an update to
> take effect" notifications.

(2) is a incredibly large amount of work longer time. And when
distributions merge your feature they become committed to it so even if
you go away they would still need to maintain it on their own. Since
they understand how much work this is they likely won't do it in the
first place. Really it's far  better to just merge if you want it to
make it out of the "toy" stage.

-Andi
