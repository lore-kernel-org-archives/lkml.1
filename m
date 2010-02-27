Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968618Ab0B0Qsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:48:32 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:51993 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S968594Ab0B0Qsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:48:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JX6EDqjeAfovKXMYz6/JooS6HstWKR/c41KFfDLRUOASzrCNspg78fKCaAWSiN9j7AUENSkKvfz45h7e/VEtIlWeO/3J12G86H5Xt7nPccmVvsHkpBy4rGazqnLZomiU;
Date: Sat, 27 Feb 2010 08:49:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
Message-ID: <20100227084906.6b05fa5e@jbarnes-piketon>
In-Reply-To: <84144f021002270417j4d690ad2qf5db26b2b6dad232@mail.gmail.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	<20100227041815.GA12956@kroah.com>
	<alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
	<d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
	<20100227051737.GA14976@kroah.com>
	<20100227052648.GA31418@kroah.com>
	<d9def9db1002262138q63c410b7ga7c04f35b6f154ff@mail.gmail.com>
	<20100227054808.GA32225@kroah.com>
	<d9def9db1002270300g7e256fc6n6fbb4fd08d951fb8@mail.gmail.com>
	<84144f021002270415r7c61236elb0208cd5d0821ab5@mail.gmail.com>
	<84144f021002270417j4d690ad2qf5db26b2b6dad232@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 14:17:14 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Sat, Feb 27, 2010 at 2:15 PM, Pekka Enberg
> <penberg@cs.helsinki.fi> wrote:
> > On Sat, Feb 27, 2010 at 1:00 PM, Markus Rechberger
> > <mrechberger@gmail.com> wrote:
> >>> Linus, I know you didn't want to do a kzalloc, but it looks like
> >>> this is the easiest/simplest thing to do, unless you can think of
> >>> something else?
> >>
> >> do you have any idea what to cherrypick in order to get rid of that
> >> flickering with the intel GM45?
> >> The flickering itself occures randomly, it was not there with the
> >> original Ubuntu kernel (2.6.31 with alot patches)
> >> This is pretty much a standard graphicchip nowadays....
> >
> > Yeah, same here. I tried to bisect the damn thing but didn't find
> > any single commit. I think the problem was introduced in in the DRM
> > merge between 2.6.31 and 2.6.32-rc1. Some people suggested
> > privately that it might be related to frame buffer compression.
> > Unfortunately I wasn't able to revert that particular patch.
> 
> Btw, after I reinstalled Ubuntu 9.10 from scratch for unrelated
> reasons, I haven't seen the flicker effect. Dunno if that's just a
> coincidence or if userspace has something to do with the bug.

Some people reported ACPI related flicker due to lid detection taking a
long time and X periodically probing for it.  Maybe that's what you
were seeing?

-- 
Jesse Barnes, Intel Open Source Technology Center
