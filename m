Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYLGIaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYLGIaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYLGIaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:30:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45752 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYLGIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:30:12 -0500
Date: Sun, 7 Dec 2008 08:55:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: odd habits with binary blobs.....
Message-ID: <20081207075542.GA1455@ucw.cz>
References: <529873894@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529873894@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-03 22:40:51, devzero@web.de wrote:
> hello, 
> 
> i gave r1soft`s new/free "hot copy" a try today and .... failed:
> 
> vserver2:/tmp/usr/sbin # ./hcp-setup
> Gathering kernel information
> Gathering kernel information complete.
> Error: A network error occurred connecting to 'kmod32.r1soft.com'
> 
> what a pain....trying to setup a linux kernel module, the installer wants to phone home - and fails.
> 
> but it`s even worse - http://wiki.r1soft.com/display/LTR1D/hcp-setup tells:
> 
> BUILDING HOT COPY DRIVER FROM SOURCE
> 
> hcp-setup will tar up your kernel source tree or headers and upload them to an R1Soft build server over HTTPS using XML-RPC. Once your system's kernel headers or source have been uploaded the R1Soft build server will compile a Hot Copy device driver as a kernel module and hcp-setup will automatically download it to your system.
> 
> In order for hcp-setup to work your Linux server must have HTTPS Internet access to kmod32.r1soft.com (32-bit systems) and kmod64.r1soft.com (64-bit systems)
> 
> 
> how weird is THAT?
> 
> did anybody ever come across such "build binary blobs remotely" system ?
> 
> 
> ok, disqualified.  won`t touch it again, as i also don`t know what REALLY is transferred to the vendor - but i wonder what kernel devs think about such build system and what in-kernel alternative exists for this. (i think it doesn`t exist - but maybe somebody working on that ?)
> 

Hmm. Gcc was not really designed to prevent .c source from exploiting
it.

So I guess you could have some phun :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
