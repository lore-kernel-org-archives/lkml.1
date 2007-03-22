Return-Path: <linux-kernel-owner+w=401wt.eu-S965713AbXCVFXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbXCVFXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXCVFXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:23:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54159 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965713AbXCVFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:23:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Unset msi and msix flags on pci_device_disable
References: <4601B012.6070802@m3y3r.de>
Date: Wed, 21 Mar 2007 23:23:33 -0600
In-Reply-To: <4601B012.6070802@m3y3r.de> (Thomas Meyer's message of "Wed, 21
	Mar 2007 23:22:10 +0100")
Message-ID: <m1tzwdam22.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> The commit f5f2b13129a6541debf8851bae843cbbf48298b7 broke suspend/resume
> to disk two or more  times in a row. This patches fixes the problem:

Please clue me in, on what the problem is, I see why my patch would
have changed things I don't see how it is breaking things.  Clearing
the device bits has no effect on the hardware and it leaks our
msi handling data structures.

What is the user doing that this code broke?

I will be happy to work through a proper fix but this isn't it.

If this is actually helps something I am tempted to make the
added lines say WARN_ON.....

But I would really like to understand the nature of the problem
so that we can do something to fix it properly.

Eric
