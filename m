Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZKBG2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZKBG2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZKBG2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:28:12 -0500
Received: from ix.technologeek.org ([213.41.157.215]:51239 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753290AbZKBG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:28:11 -0500
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 01:28:11 EST
From: Julien BLACHE <jb@jblache.org>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
Date: Mon, 02 Nov 2009 07:17:26 +0100
In-Reply-To: <alpine.OSX.1.10.0911012023020.55434@caridad.local> (Ryan
	C. Gordon's message of "Sun, 1 Nov 2009 21:21:47 -0500 (EST)")
Message-ID: <87zl75h2mh.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ryan C. Gordon" <icculus@icculus.org> wrote:

Hi,

With my Debian Developer hat on...

> Package managers are a _fantastic_ invention. They are a killer
> feature over other operating systems, including ones people pay way
> too much money to use. That being said, there are lots of places where
> using a package manager doesn't make sense:

> experimental software that might have an audience but isn't ready for
> wide adoption

That usually ships as sources or prebuilt binaries in a tarball - target
/opt and voila! For a bigger audience you'll see a lot of experimental
stuff that gets packaged (even in quick'n'dirty mode).

> software that isn't appropriate for an apt/yum repository

Just create a repository for the damn thing if you want to distribute it
that way. There's no "appropriate / not appropriate" that applies here.

> software that distros refuse to package but is still perfectly useful

Look at what happens today. A lot of that gets packaged by third
parties, and more often than not they involve distribution
maintainers. (See debian-multimedia, PLF for Mandriva, ...)

> closed-source software

Why do we even care? Besides, commercial companies can just stop sitting
on their hands and start distributing real packages. It's no different
from rolling out a Windows Installer or Innosetup. It's packaging.

> and software that wants to work between distros that don't have 
> otherwise-compatible rpm/debs (or perhaps no package manager at all).

Tarball, /opt, static build.


And, about the /lib, /lib32, /lib64 situation Debian and Debian-derived
systems, the solution to that is multiarch and it's being worked
on. It's a lot better and cleaner than the fat binary kludge.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
