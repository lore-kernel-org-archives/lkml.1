Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYKFVOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYKFVOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYKFVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:13:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:32768 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYKFVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:13:51 -0500
Date: Thu, 6 Nov 2008 21:50:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: introduce KECHO convenience echo
Message-ID: <20081106205048.GA2972@uranus.ravnborg.org>
References: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:31:34AM -0500, Mike Frysinger wrote:
> There is a bunch of places in the build system where we do 'echo' to show
> some nice status lines.  This means we still get output when running in
> silent mode.  So declare a new KECHO variable that only does 'echo' when we
> are in a suitable verbose build mode.

Nice idea.
I will add it as soon as I start working on kbuild-next
Same for your other two patches.

A lot of the kbuild stuff today is using lowercase to
avoid all the typical SCREAMING in Makefiles so I
may end up using $(kecho).

	Sam
