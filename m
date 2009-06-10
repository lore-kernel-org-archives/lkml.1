Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZFJGpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZFJGpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZFJGpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:45:07 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44039 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZFJGpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:45:06 -0400
Date: Wed, 10 Jun 2009 08:47:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kbuild tree build warning
Message-ID: <20090610064723.GA25493@uranus.ravnborg.org>
References: <20090610115255.035da856.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610115255.035da856.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 11:52:55AM +1000, Stephen Rothwell wrote:
> Hi Sam,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> In file included from arch/x86/kernel/vmlinux.lds.S:23:
> include/asm-generic/vmlinux.lds.h:726:47: warning: backslash-newline at end of file
> 
> Caused by commit ef53dae8658cf0e93d380983824a661067948d87 ("Improve
> vmlinux.lds.h support for arch specific linker scripts").

I already fixed this locally but I forgot to do a "git commit --amend" :-)
Will be fixed in next push of kbuild-next.

	Sam
