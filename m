Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYDXNm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYDXNm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYDXNmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:42:50 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:10356 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYDXNmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:42:49 -0400
To: Jeff Arnold <jbarnold@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
Date: Thu, 24 Apr 2008 15:42:46 +0200
In-Reply-To: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> (Jeff Arnold's message of "Wed, 23 Apr 2008 14:59:05 -0400 (EDT)")
Message-ID: <87r6cvgyi1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 13:35:57.0353 (UTC) FILETIME=[20697990:01C8A610]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Arnold <jbarnold@MIT.EDU> writes:

> I've put together an automatic system for applying kernel security
> patches to the Linux kernel without rebooting it, and I wanted to
> share this system with the community in case others find it useful or
> interesting.

Sounds interesting.  You should consider bringing the kernel module
up to kernel coding standards and submitting it for mainline. That
would be the best way to get more users and testers.

Have you also considered to turn it into a generic incremental binary
linker too? I guess most of the infrastructure needed for it is
already there. Even though gold looks very promising long link times
can be still a problem in development.

-Andi
