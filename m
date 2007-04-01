Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbXDAVFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbXDAVFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965176AbXDAVFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:05:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42434 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153AbXDAVFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:05:37 -0400
Date: Sun, 1 Apr 2007 23:06:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Edgardo Hames <ehames@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Rebuilding and checksumming the Linux kernel
Message-ID: <20070401210622.GC10761@uranus.ravnborg.org>
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 03:56:30PM -0300, Edgardo Hames wrote:
> I'm working on a project with teams spread across the world and we all
> work on the same repository patching the kernel and then integrating
> into a common main branch. Even though we label the source code, we
> would like to make sure that we are all building the same kernel by
> running md5sum on the resulting binary.
> 
> Right now, this is not possible because the kernel includes a
> timestamp and a build number on the binary. What are this timestamps
> used for? Can we just remove them? Is there any other thing that may
> lead to different binaries? (we are using the exact toolchains and
> build machines, so we can assume that the same executable is generated
> if the input source is the same).

Soon you will be able to say:

KBUILD_BUILD_TIMESTAMP="2007-02-30 01:02.03" KBUILD_BUILD_VERSION=99 make

It will hit -mm soon and mainline in next merge window.
Patch is in kbuild.git at git.kernel.org.

	Sam
