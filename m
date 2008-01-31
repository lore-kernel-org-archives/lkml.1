Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYAaA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYAaA62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYAaA6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:58:18 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47985 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbYAaA6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:58:17 -0500
Date: Wed, 30 Jan 2008 19:58:16 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Guenter Kukkukk <linux@kukkukk.com>, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080131005816.GB26259@csclub.uwaterloo.ca>
References: <20080128220835.GF8767@does.not.exist> <200801302216.13788.linux@kukkukk.com> <20080130174103.17ff8197@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130174103.17ff8197@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 05:41:03PM -0500, Jeff Layton wrote:
> Some of our older products use smbfs, but our newer stuff (RHEL5 and
> up) have smbfs disabled. Fedora has had smbfs disabled for quite some
> time as well. I've heard very few complaints (though maybe they're just
> not getting to me).
> 
> I have no problem with targeting smbfs for removal, but I thought
> Andrew had an unofficial policy that we should first mark things to be
> deprecated, and then remove them 2 releases later. That seems like a
> sensible policy to me. If we mark it deprecated in 2.6.25 then we can
> remove it after 2.6.26 is released.
> 
> It might not even hurt to have a nice loud printk when the smbfs
> module is plugged in to warn users that it's slated to be removed,
> and that they should move to CIFS as soon as possible.
> 
> It would be ideal if someone were to report these problems as bugs. I
> remember some of those in the past, but haven't heard of any cases of
> that sort of thing for some time. When I have, Steve has generally
> been very good about tracking down the cause and fixing it.

But if smbfs works when cifs doesn't, most people figure it's supposed
to be that way and smbfs works so what's to complain about?

I too have had cifs not work for some devices, and I actually thought
that was intentional.  I will try to keep a note of what device that
was.

--
Len Sorensen
