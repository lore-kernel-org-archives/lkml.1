Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYEKINj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYEKINj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 04:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYEKINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 04:13:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60508 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYEKINW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 04:13:22 -0400
Date: Sun, 11 May 2008 10:13:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: escape meta characters in regular expression in make TAGS
Message-ID: <20080511081358.GB25696@uranus.ravnborg.org>
References: <20080507.160431.251452611.yamato@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507.160431.251452611.yamato@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 04:04:31PM +0900, Masatake YAMATO wrote:
> Hi,
> 
> 
> Alexey Dobriyan <adobriyan@gmail.com> introduced a code adds
> menuconfig SOMETHING in Kconfig to tags output when you did "make tags".
> 
> See http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=80ff26241623875636674a31c0540a78c0fb5433
> 
> "make tags" may work fine with his code. However make TAGS doesn't work well
> because etags command requires backslashes to escape meta characters like 
> `(', `)' and `|'.
> 
> Here is a patch.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>

Thanks Masatake.

Applied and pushed out to kbuild-fixes.

	Sam
