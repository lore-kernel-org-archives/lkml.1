Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbXGFLoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbXGFLoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXGFLn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:43:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760027AbXGFLnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:43:55 -0400
Subject: Re: [PATCH] Libertas: Fix regression in cmd.c introduced in commit
	18c96c3497aa871608d57ca5e08de3558159a6c9
From: Dan Williams <dcbw@redhat.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Guillaume LECERF <glecerf@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <a781481a0707060029r3ebf237bl84e27247f0943820@mail.gmail.com>
References: <b8e9195f0707051609v36182409mc07f030cca790a7a@mail.gmail.com>
	 <a781481a0707060029r3ebf237bl84e27247f0943820@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 07:48:13 -0400
Message-Id: <1183722493.15222.3.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 12:59 +0530, Satyam Sharma wrote:
> Hi Guillaume,
> 
> [ Added relevant folks to Cc: ]

Botched backport, head is correct.  It's worth noting that WPA didn't
work before the original commit at _all_, and after the commit it would
actually work, but you probably couldn't turn it off :)

Thanks for the catch, I'll fix and push to linville.

dan

> On 7/6/07, Guillaume LECERF <glecerf@gmail.com> wrote:
> > [...]
> >
> > --- a/drivers/net/wireless/libertas/cmd.c
> > +++ b/drivers/net/wireless/libertas/cmd.c
> > @@ -241,7 +241,7 @@
> >                 if (*enable)
> >                         penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
> >                 else
> > -                       penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
> > +                       penableRSN->enable = cpu_to_le16(cmd_disable_rsn);
> >         }
> >
> >         lbs_deb_leave(LBS_DEB_CMD);
> >
> 
> Thanks for the patch (looks reasonable to me), but:
> 
> 1. No point sending a patch without a "Signed-off-by:" line.
> 2. Changelog (a few lines of explanation before signed-off-by) must
> specify what was wrong, and why the patch is correct.
> 3. Always Cc: relevant maintainers or at least _somebody_ who
> _will_ pick it up.
> 4. Gmail has done horrible things to the patch as usual, use some
> other mailer or script.
> 
> And in general, please read: Documentation/SubmittingPatches
> and http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
> 
> Satyam

