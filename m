Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXDAVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXDAVxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXDAVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:53:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:11075 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXDAVxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q2NWjLTEeUfSl0FEN0hXg5gFtw/k8luCJOLV2LZa0xtY6AQWYWhBXWXsQMDsqmq1YwZ3tygbUq4T6VUpfTXOiWUSRoC6YSANGh+lfUmnvJRea299XzR5FzhT655CLJwKoaiKHySC2ltRtPaI3eJEwp1F3jAuKeSa3SApwSaRn8c=
Message-ID: <478c16ae0704011453j7942bb3aq15c9930045db9e50@mail.gmail.com>
Date: Sun, 1 Apr 2007 18:53:18 -0300
From: "Edgardo Hames" <ehames@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Rebuilding and checksumming the Linux kernel
Cc: "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <20070401210622.GC10761@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
	 <20070401210622.GC10761@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Apr 01, 2007 at 03:56:30PM -0300, Edgardo Hames wrote:
> > I'm working on a project with teams spread across the world and we all
> > work on the same repository patching the kernel and then integrating
> > into a common main branch. Even though we label the source code, we
> > would like to make sure that we are all building the same kernel by
> > running md5sum on the resulting binary.
> >
> > Right now, this is not possible because the kernel includes a
> > timestamp and a build number on the binary. What are this timestamps
> > used for? Can we just remove them? Is there any other thing that may
> > lead to different binaries? (we are using the exact toolchains and
> > build machines, so we can assume that the same executable is generated
> > if the input source is the same).
>
> Soon you will be able to say:
>
> KBUILD_BUILD_TIMESTAMP="2007-02-30 01:02.03" KBUILD_BUILD_VERSION=99 make
>
> It will hit -mm soon and mainline in next merge window.
> Patch is in kbuild.git at git.kernel.org.

This is so much more than I could have asked for! I will try this
patch on my version of the kernel.

Thanks a lot,
Ed
-- 
Encontrá a "Tu psicópata favorito" http://tuxmaniac.blogspot.com

The future is not what it used to be.
-- Paul Valéry
