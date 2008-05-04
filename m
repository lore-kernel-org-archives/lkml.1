Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYEDJhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYEDJhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYEDJgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:36:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:58500 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYEDJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IHK3pa0h7S313Azj3I62tOR0G0/dJglDWyh9X9oo1vFhiwPyYSoZENrGuxADhchMSHLBRVtJB4q+wZEbxuRNIwuzezG4hg/NQzbo/46TiPC86BbACAr+I9957TcDvBUrcgtKRuvacVGJYOkQTjzG5c7LLo3VSXyIYdor6VcYa4o=
Date: Sun, 4 May 2008 13:36:27 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] power_supply: Support serial number and ACR in
	olpc_battery
Message-ID: <20080504093627.GA27950@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080430163002.3c768ae0@ephemeral> <20080502225849.GA26024@zarina> <20080504013142.03c8ad0b@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080504013142.03c8ad0b@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:31:42AM -0400, Andres Salomon wrote:
> On Sat, 3 May 2008 02:58:49 +0400
> Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > On Wed, Apr 30, 2008 at 04:30:02PM -0400, Andres Salomon wrote:
> > > From: David Woodhouse <dwmw2@infradead.org>
> > > 
> > > This adds serial number and accumulated current support to the OLPC
> > > battery driver.
> > 
> > How PROP_ACCUM_CURRENT is different from PROP_CHARGE_NOW (uAh)?
> > 
> > The DS2760 is already using the later to report its ACR register...
> > 
> 
> Hm, I can change that.  In the meantime, I've stripped out the
> ACR stuff.  Can you please use the following patch instead?  The change
> doesn't conflict with the other 3 patches.

Thanks, applied to battery-2.6.git. Please see if everything is okay.

Do you want to see these patches in 2.6.26? I think it's a bit late
(-rc1 is already released), but I also believe these patches are quite
useful for OLPC and actually they do not touch anything but single
driver...


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
