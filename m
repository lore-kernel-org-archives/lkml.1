Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYHOTt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYHOTt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYHOTtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:49:21 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:26748 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbYHOTtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:49:21 -0400
Date: Fri, 15 Aug 2008 21:49:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix creation of include2/asm symlink
Message-ID: <20080815194954.GA18377@uranus.ravnborg.org>
References: <s5hod3u5r3d.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hod3u5r3d.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 03:45:58PM +0200, Takashi Iwai wrote:
> The directory include2/asm can point wrongly to a non-existing
> directory on architectures that have moved include/asm under arch/*.
> 
> This patch fixes it by checking firstly whether arch/*/include/asm is
> available.

Hi Takashi.

I understand why you try to avoid include2/asm as it is not pretty.
And I had a similar patch once - but I dropped it as the symlink do
not harm and it will anyway be gone when the remaining architectures
has shifted to use arch/$ARCH/include/...

So I will not apply it.

	Sam
