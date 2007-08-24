Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbXHXMvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbXHXMvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763000AbXHXMu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:50:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40480 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761226AbXHXMu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:50:57 -0400
Date: Fri, 24 Aug 2007 14:50:46 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Kentaro Takeda <k.takeda26@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 02/15] Kconfig and Makefile for TOMOYO Linux.
In-Reply-To: <46CED2FC.9030700@gmail.com>
Message-ID: <Pine.LNX.4.64.0708241449210.2460@twin.jikos.cz>
References: <46CED214.6050505@gmail.com> <46CED2FC.9030700@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Kentaro Takeda wrote:

> Kconfig and Makefile for TOMOYO Linux.
> TOMOYO Linux is placed in security/tomoyo .
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/Kconfig         |    1 +
>  security/Makefile        |    1 +
>  security/tomoyo/Kconfig  |   18 ++++++++++++++++++
>  security/tomoyo/Makefile |    3 +++
>  4 files changed, 23 insertions(+)

Just a trivial minor nitpick - IMHO this breaks bisectability. It might be 
better to add the Kconfig/Makefile patch at the end of the whole series, 
so that bisect doesn't end up in the tree in which Makefile references 
non-exsting files/directories.

-- 
Jiri Kosina
