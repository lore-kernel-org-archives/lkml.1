Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbZKRFQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbZKRFQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZKRFQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:16:09 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57676 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZKRFQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZZBAwvZD4GtSwrvv1B/sGeXZmVWjNg3Ymr0wvL/EtRprgc46+Ffxxd6yK3vTcMAQ43
         gXC4oTHwRx+rm0PN1Z5cdMbDrDy1lsCbXUCGSZ6iIfdy1ejmTYTmlDbHFMNLpagwCd7c
         p1vFfiaW1YwWmyyvo9uUPPa+V5LBkC28qGop4=
Date: Tue, 17 Nov 2009 21:16:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: atkbd - add forced release kays quirk for
	Samsung N130
Message-ID: <20091118051605.GA31480@core.coreip.homeip.net>
References: <20091116171814.GA26183@sig21.net> <20091116195443.GE24026@core.coreip.homeip.net> <20091116213425.GA2128@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116213425.GA2128@sig21.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 10:34:25PM +0100, Johannes Stezenbach wrote:
> Hi Dmitry,
> 
> On Mon, Nov 16, 2009 at 11:54:43AM -0800, Dmitry Torokhov wrote:
> > On Mon, Nov 16, 2009 at 06:18:14PM +0100, Johannes Stezenbach wrote:
> > > Samsung N130 has the same function key quirks as the NC10.
> > > 
> > > Signed-off-by: Johannes Stezenbach <js@sig21.net>
> > > ---
> > > It would be nice if this could go into 2.6.32.  It might also be
> > > suitable for stable.
> > 
> > 2.6.32 will allow manipulating force release quirk from userspace
> > (sysfs) so I stopped accepting in-kernel quirks like this one.
> 
> OK, makes sense.  Will this be put in udev along with
> the keymap setup for the function keys? 

I think that is the best place to put it, yes.

> If yes, is
> there already an example how to do it correctly so 
> I can submit a patch to add the N130 support there?

No, but you can be the first and pave the road ;)

-- 
Dmitry
