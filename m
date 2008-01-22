Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYAVWWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYAVWWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAVWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:21:56 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:44866 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbYAVWVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:21:55 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <47965974.5080502@zytor.com>
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
	 <1201023401.5643.52.camel@localhost.localdomain>
	 <479634A9.1090908@zytor.com>
	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>
	 <1201035150.15491.70.camel@cthulhu.hellion.org.uk>
	 <47965974.5080502@zytor.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 22:21:44 +0000
Message-Id: <1201040504.15491.80.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 13:00 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > On Tue, 2008-01-22 at 21:36 +0100, Ingo Molnar wrote:
> >> * H. Peter Anvin <hpa@zytor.com> wrote:
> >>
> >>>> Seems reasonable to me. I'll integrate your asm diff with the other 
> >>>> changes and give it a whirl.
> >>> This version boots into userspace on both PAE and !PAE.  You want to 
> >>> take it from here?
> >> ok, i'll wait for Ian to submit the final (tested) version then. A few 
> >> possible complications are: PSE-less boxes, 32-bit PAGEALLOC bootups 
> >> with tons of RAM, NX-less boxes and NX-able boxes :)
> > 
> > I'm not sure I can promise that sort of coverage ;-) Will test on what
> > hardware I've got available...
> > 
> 
> I tend to use simulators (e.g. Qemu) quite a bit.  They let you tune 
> this kind of stuff.

So do I but I'd never really investigated the option to fiddle with the
CPU type -- very useful though, thanks for the tip!

Ian.

-- 
Ian Campbell

No one can feel as helpless as the owner of a sick goldfish.

