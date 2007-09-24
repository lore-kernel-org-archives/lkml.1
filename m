Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbXIXSM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbXIXSM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbXIXSMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:12:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34821 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755729AbXIXSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:12:49 -0400
Date: Mon, 24 Sep 2007 20:13:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Indan Zupancic <indan@nul.nu>, Rob Landley <rob@landley.net>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] Linux-tiny project revival
Message-ID: <20070924181307.GC6800@stusta.de>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net> <200709201818.42125.rob@landley.net> <38197.81.207.0.53.1190329581.squirrel@secure.samage.net> <20070921062949.GA17131@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070921062949.GA17131@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 08:29:49AM +0200, Sam Ravnborg wrote:
>...
> So __FILE__ expand differently depending on the path on
> the gcc command line.
> I once posted a patch to fix up on this, especialy for BUG_ON and friends.
> The solution was to let kbuild generate the filename and to use
> this define in the source code.
> But a quick grep for __FILE__ in the kernel source made me chicken out.
> Simply too much chrunch at that time to justify it.
>...

Although it's not a big problem, we have the same issue with gcc 
warnings and errors displaying the full path with O= builds making the 
error messages quite long.

The root is that for O= builds we are feeding gcc the full path
We might perhaps attack it at this point?

The simplest solution that comes into my mind would be to create links 
for the source file in the output dir before calling gcc and then give 
gcc the link as input file.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

