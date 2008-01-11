Return-Path: <linux-kernel-owner+w=401wt.eu-S1761709AbYAKRCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761709AbYAKRCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760311AbYAKRBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:01:54 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37344 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760301AbYAKRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:01:53 -0500
Subject: Re: INITIO scsi driver fails to work properly
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: linux-scsi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
	 <1200066295.3286.19.camel@localhost.localdomain>
	 <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 11:01:43 -0600
Message-Id: <1200070903.3286.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 18:44 +0200, Filippos Papadopoulos wrote:
> On Jan 11, 2008 5:44 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > >
> > > I havent reported "initio: I/O port range 0x0 is busy."
> >
> > Sorry ... we appear to have several reporters of different bugs in this
> > thread.  That message was copied by Chuck Ebbert from a Red Hat
> > bugzilla ... I was assuming it was the same problem.
> >
> > > I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.
> >
> > First off, has this driver ever worked for you in 2.6?  Just booting
> > SLES9 (2.6.5) or RHEL4 (2.6.9) ... or one of their open equivalents to
> > check a really old kernel would be helpful.  If you can get it to work,
> > then we can proceed with a patch reversion regime based on the
> > assumption that the problem is a recent commit.
> 
> Yes it works under 2.6.16.13.  See the beginning of this thread, i
> mention there some things about newer versions.

Thanks, actually, I see this:

> I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
> OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
> drivergets loaded during the installation process, yast reports that no hard
> disk is found.

Could you try with a vanilla 2.6.22 kernel?  The reason for all of this
is that 2.6.22 predates Alan's conversion of this driver (which was my
95% candidate for the source of the bug).  I want you to try the vanilla
kernel just in case the opensuse one contains a backport.

Thanks,

James


