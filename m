Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbXKVPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbXKVPim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 10:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXKVPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 10:38:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:11609 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXKVPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 10:38:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jD+/2wloEk2g7tXgmU8CX8fwEYn64aFicZjcbQpZjOLKVmaPihxOsl5VAhsQR77ChkzRD4V9ZeUsI5KT8LmzEXcflpg+Y/o5yCCYodaJdO+jXkP7v/FNOggjHt+SZYz0xz7jaSgwGeod35tBXAnaz901AfejQwpj8aM0UEbyOgU=
Date: Thu, 22 Nov 2007 18:38:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] PPC: trivial fix of missed increment on counter
Message-ID: <20071122153823.GA7273@cvg>
References: <aa79d98a0711210056n6cc951atf4c6af5be26c1ed0@mail.gmail.com> <aa79d98a0711210258t3e6f5532oe710c04b93b06c8@mail.gmail.com> <20071122152029.GA7678@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122152029.GA7678@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Olof Johansson - Thu, Nov 22, 2007 at 09:20:29AM -0600]
| On Wed, Nov 21, 2007 at 01:58:06PM +0300, Cyrill Gorcunov wrote:
| > On 11/21/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > > This patch does fix missed increment on counter
| > >
| > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > > ---
| > > Sorry for that nonstandart patch submission - I've only access
| > > to gmail with Internet Explorer on my work. If that is not OK - will resend
| > > the patch today evening with mutt.
| > >
| > >
| > Oops - it seems the patch is corrupted a bit. Drop it please - will
| > resend today evening. Sorry.
| 
| Thanks for the fix, but please cc the maintainer (me) next time, as well
| as the arch list (linuxppc-dev@ozlabs.org)?
| 
| That loop could actually even easier be converted to a
| for_each_compatible_node() iteration. There's never more than one
| interface on the current boards but it's still nicer coding.
| 
| Thanks,
| 
| -Olof
| 

Sorry Olof for missing you. Will cc you and a list next time.
I'm trying to convert all for(;;) cycles to for_each_.. macro
now (actually during the convertation I found a few potential NULL
pointer dereferences so they are going first to list as I've done on them).
So as only I have it done I'll send it to a list (and you too ;) Thanks.

		Cyrill

