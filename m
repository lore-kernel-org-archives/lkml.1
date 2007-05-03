Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXECW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXECW6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXECW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:58:41 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2110 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbXECW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:58:40 -0400
Date: Fri, 4 May 2007 02:55:06 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: ian <spyro@f2s.com>
Cc: Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] [PATCH 3/8] Universal power supply class
	(was: battery class)
Message-ID: <20070503225506.GA20742@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <1178230466.20102.27.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1178230466.20102.27.camel@wirenth>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:14:26PM +0100, ian wrote:
> On Fri, 2007-05-04 at 01:31 +0400, Anton Vorontsov wrote:
> >     # cat /sys/class/power\ supply/ac/type
> >         AC
> > 
> >         # cat /sys/class/power\ supply/usb/type
> >         USB 
> 
> isnt that a bit redundant?

Let me note that "usb"/"ac" is just names pda-power driver
gives for these supplies. So, it's not power supply class issue,
but pda-power.

As for pda-power.. Yes, it can name them "supply0" and "supply1"...
Or maybe "pda-supplyX", but I don't see any need to maim name just
because it is very similar to its type. ;-) Anyhow I don't care
much, i.e. if you or anyone else will insist, I'll change
pda-power's supply names with no problems.

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
