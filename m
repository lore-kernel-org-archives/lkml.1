Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYG2Adw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYG2Adw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYG2Adn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:33:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36647 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYG2Adm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:33:42 -0400
Date: Tue, 29 Jul 2008 01:33:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Thomas Meyer <thomas@m3y3r.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org
Subject: Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree
	for July 17: early crash on x86-64)
Message-ID: <20080729003318.GE28946@ZenIV.linux.org.uk>
References: <20080718012842.690b8346.sfr@canb.auug.org.au> <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com> <20080719035231.GU28946@ZenIV.linux.org.uk> <200807192042.06988.rjw@sisk.pl> <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au> <1216546973.3217.6.camel@dhcppc2> <20080720121559.GV28946@ZenIV.linux.org.uk> <1217266358.20373.54.camel@moss-spartans.epoch.ncsc.mil> <Xine.LNX.4.64.0807290736440.30242@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0807290736440.30242@us.intercode.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 07:38:17AM +1000, James Morris wrote:
> On Mon, 28 Jul 2008, Stephen Smalley wrote:
> 
> > SELinux needs MAY_APPEND to be passed down to the security hook.
> > Otherwise, we get permission denials when only append permission is
> > granted by policy even if the opening process specified O_APPEND.
> > Shows up as a regression in the ltp selinux testsuite, fixed by
> > this patch.
> > 
> > Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
> 
> Applied to  
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#hotfixes
> 
> 
> Al, holler if you want to push this through your tree.

Applied, will push along with other patches tonight...
