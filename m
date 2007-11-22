Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXKVPS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXKVPS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 10:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXKVPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 10:18:18 -0500
Received: from lixom.net ([66.141.50.11]:33436 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXKVPSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 10:18:17 -0500
Date: Thu, 22 Nov 2007 09:20:29 -0600
From: Olof Johansson <olof@lixom.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] PPC: trivial fix of missed increment on counter
Message-ID: <20071122152029.GA7678@lixom.net>
References: <aa79d98a0711210056n6cc951atf4c6af5be26c1ed0@mail.gmail.com> <aa79d98a0711210258t3e6f5532oe710c04b93b06c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0711210258t3e6f5532oe710c04b93b06c8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 01:58:06PM +0300, Cyrill Gorcunov wrote:
> On 11/21/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > This patch does fix missed increment on counter
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> > Sorry for that nonstandart patch submission - I've only access
> > to gmail with Internet Explorer on my work. If that is not OK - will resend
> > the patch today evening with mutt.
> >
> >
> Oops - it seems the patch is corrupted a bit. Drop it please - will
> resend today evening. Sorry.

Thanks for the fix, but please cc the maintainer (me) next time, as well
as the arch list (linuxppc-dev@ozlabs.org)?

That loop could actually even easier be converted to a
for_each_compatible_node() iteration. There's never more than one
interface on the current boards but it's still nicer coding.

Thanks,

-Olof
