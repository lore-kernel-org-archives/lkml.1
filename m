Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXGQFT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXGQFT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXGQFTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:19:18 -0400
Received: from 1wt.eu ([62.212.114.60]:3353 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXGQFTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:19:17 -0400
Date: Tue, 17 Jul 2007 07:16:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tony Borras <tonyb@sysdev.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-ID: <20070717051646.GD943@1wt.eu>
References: <20070716133025.55327074.tonyb@sysdev.org> <20070716163047.55a21e6c.tonyb@sysdev.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716163047.55a21e6c.tonyb@sysdev.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Jul 16, 2007 at 04:30:47PM -0800, Tony Borras wrote:
> I did get the current 'pre' set of 2.4.35 (circa early
> June) patches and applied to 2.4.34.5.  After fixing a goto
> mislable in one of the patches (dont remember if it was one of
> the patch-2.4.34.? or patch-2.4.35.pre5), managed to build a
> vmlinuz-2.4.35 successfully.

could you please report what the problem was, in case it's not fixed
yet ?

> Just wondered whether to expect an abandonded tree, in which
> case I will fly with this 2.4.35 build or should wait for its
> eventual release.
 
No it's not abandonned at all !!!

The difficulty with 2.4 is to get user feedback on patches. While in 2.6,
there are hundreds or thousands of testers for every release, in 2.4,
I have to wait longer after every release in order to start collecting
problem reports, or confirmation of fixes. People using it in production
generally cannot reboot a machine in the evening just to try a patch.
Also, subsystem maintainers have less time to spend on it and are
themselves slowed down by the slow feedback process.

That's merely why I maintain a parallel 2.4.34.X stable branch. I thought
I could release one version every 6 months, but I think that this delay
will probably slightly increase after 2.4.35, we'll see.

I still have a few patches to merge, and I expect to be able to work on
them next week-end, then release -rc1, which I expect to be the only -rc
before -final (which will probably not be true as in every -rc).

Thanks,
Willy

