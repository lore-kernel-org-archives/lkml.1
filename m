Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYBSPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYBSPLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYBSPLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:11:04 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:36003 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752675AbYBSPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:11:03 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 02:10:28 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 3/9]
Message-ID: <20080219151028.GA28294@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BAEABF.6050005@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:42:07PM +0300, Pavel Emelyanov wrote:
> Nick Andrew wrote:
> > On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> >> Here is a series of 9 patches to init/Kconfig intended to improve the
> >> usefulness and consistency of the help descriptions. The patches are
> >> against linux-2.6.24.2.
> >> [...]
> >> Patch 3
> >> 	USER_NS
> >> 	PID_NS
> 
> What about UTS_NS, IPC_NS and NET_NS? 
> Their descriptions can be improved in the same way :)

So far I have edited only init/Kconfig, that's what these 9
patches are for. Next I'll do block/Kconfig. Eventually I expect
to get to net/Kconfig which is where NET_NS is configured,
but I don't know where UTS_NS and IPC_NS come from in 2.6.24.2.

I expect I'll have to start patching against a git tree soon,
to be sure to see the latest code. I assume this should be
Linus' tree?

Is there any actual documentation on user namespaces and friends?
I think I grasp the pid namespaces concept; I am having a little
difficulty visualising what function user namespaces performs.
"provide different user info" isn't a very useful description and
I'd fix it if I understood what it is supposed to mean.

To make a guess at it, how about:

   Enable support for user namespaces.

   This is a function used by container-based virtualisation systems
   (e.g. vservers). User namespaces ensures that processes with the
   same uid which are in different containers are isolated from each other.

   Answer Y if you require container-based virtualisation like
   vservers. If unsure, say N.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
