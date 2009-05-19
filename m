Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZESOp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZESOp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZESOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:45:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53441 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZESOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:45:15 -0400
Date: Tue, 19 May 2009 10:41:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org, gregkh@suse.de,
       johannes@sipsolutions.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: agnx: switch config_interface to
	bss_info_changed
Message-ID: <20090519144131.GB2691@tuxdriver.com>
References: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com> <20090512164448.GJ16247@kroah.com> <a4423d670905121037i3ea96b01s68367c082802684d@mail.gmail.com> <20090512190254.GB1957@kroah.com> <a4423d670905121315g503f4f0ep6a60e9051a2aeb9d@mail.gmail.com> <a4423d670905190512x296f6b1cgaa7815fb4f17cac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670905190512x296f6b1cgaa7815fb4f17cac7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 04:12:50PM +0400, Alexander Beregalov wrote:
> 2009/5/13 Alexander Beregalov <a.beregalov@gmail.com>:
> > 2009/5/12 Greg KH <greg@kroah.com>:
> >> On Tue, May 12, 2009 at 09:37:56PM +0400, Alexander Beregalov wrote:
> >>> 2009/5/12 Greg KH <greg@kroah.com>:
> >>> > On Tue, May 12, 2009 at 03:23:13PM +0400, Alexander Beregalov wrote:
> >>> >> Fix this build error:
> >>> >> drivers/staging/agnx/pci.c: In function 'agnx_config_interface':
> >>> >> drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type
> >>> >> ..
> >>> >> drivers/staging/agnx/pci.c:424: error: unknown field 'config_interface' specified in initializer
> >>> >>
> >>> >> config_interface was removed in 2d0ddec5b2b
> >>> >> ("mac80211: unify config_interface and bss_info_changed")
> >>> >
> >>> > I do not see that patch in Linus's tree.  Is it in some other tree
> >>> > (wireless?) and not yet in mainline?
> >>> Yes, it is in wireless from linux-next.
> >>> You asked to send patches based on linux-next, right?
> >>> Should I always mark patches for staging-next tree as [PATCH -next] ?
> >>
> >> Hm, yes, -staging patches need to be against -next, but I have to be
> >> able to build these somehow on my own without the wireless tree...
> >>
> >> I think something like this might better go through the wireless tree as
> >> it depends on changes that happen there.  Sound good to you?
> > Ok, thanks Greg.
> >
> >> If so, please send them to the wireless maintainer.
> > John, will you apply it?
> 
> John?

*grumble*

I guess I will...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
