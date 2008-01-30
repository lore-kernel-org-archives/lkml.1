Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYA3Wli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYA3Wli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYA3Wl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:41:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYA3Wl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:41:28 -0500
Date: Wed, 30 Jan 2008 17:41:03 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Guenter Kukkukk <linux@kukkukk.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080130174103.17ff8197@tleilax.poochiereds.net>
In-Reply-To: <200801302216.13788.linux@kukkukk.com>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 22:16:13 +0100
Guenter Kukkukk <linux@kukkukk.com> wrote:

> Am Montag, 28. Januar 2008 schrieb Adrian Bunk:
> > I remember that there were some small things missing in CIFS for 
> > completely replacing the unmaintained smbfs when we discussed
> > removing smbfs back in 2005 due to smbfs being unmaintained.
> > 
> > CIFS has improved since, smbfs is still unmaintained, and it's
> > becoming time to finally remove smbfs.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> "... unmaintained smbfs ..." is not quite right, see
>    http://lkml.org/lkml/2007/11/6/94
> Before removing it now completely, drop
>   Jeff Layton <jlayton@redhat.com>
> a note.
> Afaik, Redhat still has customers which rely on smbfs.
> 

Some of our older products use smbfs, but our newer stuff (RHEL5 and
up) have smbfs disabled. Fedora has had smbfs disabled for quite some
time as well. I've heard very few complaints (though maybe they're just
not getting to me).

I have no problem with targeting smbfs for removal, but I thought
Andrew had an unofficial policy that we should first mark things to be
deprecated, and then remove them 2 releases later. That seems like a
sensible policy to me. If we mark it deprecated in 2.6.25 then we can
remove it after 2.6.26 is released.

It might not even hurt to have a nice loud printk when the smbfs
module is plugged in to warn users that it's slated to be removed,
and that they should move to CIFS as soon as possible.

> In addition, cifs cannot completely replace smbfs atm.
> Even todays sold NAS-boxes (often running anchient 
> samba-2.x.x) work only with smbfs on the client side.

It would be ideal if someone were to report these problems as bugs. I
remember some of those in the past, but haven't heard of any cases of
that sort of thing for some time. When I have, Steve has generally
been very good about tracking down the cause and fixing it.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>
