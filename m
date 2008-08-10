Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYHJMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYHJMz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYHJMzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:55:19 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:44728 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYHJMzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:55:18 -0400
X-Greylist: delayed 8495 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Aug 2008 08:55:17 EDT
Date: Sun, 10 Aug 2008 11:30:44 +0100
From: Grant Wilson <grant.wilson@zen.co.uk>
To: David Howells <dhowells@redhat.com>
Cc: Jasper Bryant-Greene <jasper@amiton.co.nz>, dhowells@redhat.com,
       Thomas Meyer <thomas@m3y3r.de>, James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
Message-ID: <20080810113044.19143b0a@worthy.swandive.local>
In-Reply-To: <10251.1218361539@redhat.com>
References: <1218322518.3268.0.camel@luna.unix.geek.nz>
	<1218287473.3155.13.camel@dhcppc0>
	<1218281190.3155.5.camel@dhcppc0>
	<1218214935.3146.5.camel@dhcppc0>
	<alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
	<14476.1218286327@redhat.com>
	<15386.1218290826@redhat.com>
	<10251.1218361539@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 10:45:39 +0100
David Howells <dhowells@redhat.com> wrote:

[snip]
> 
> Are you running as an unprivileged user?  If so, this may be the point that's
> biting you.  Can you try applying the attached patch to find more information?
[snip]
I'm also experiencing this on an X86_64 system as an unprivileged user.

With your patch applied I get the following repeated several times
during the boot, but with no apparent ill effects:

[   31.033195] copy_process() = -513 

When the fork call starts to fail after a few minutes the following is logged:

[  223.039938] Rlimit EAGAIN (-1 >= 16375, uid 1000)
[  223.044744] copy_process() = -11
[  226.660319] Rlimit EAGAIN (-1 >= 16375, uid 1000)
[  226.664166] copy_process() = -11

HTH.
Cheers,
GRant
