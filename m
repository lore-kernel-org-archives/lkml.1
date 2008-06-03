Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbYFCUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbYFCUme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbYFCUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:38:05 -0400
Received: from keil-draco.com ([216.193.185.50]:43728 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbYFCUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:37:55 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Date: Tue, 3 Jun 2008 16:37:52 -0400
User-Agent: KMail/1.9.9
Cc: Nix <nix@esperi.org.uk>, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
References: <20080603190235.GA9511@c2.user-mode-linux.org> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org>
In-Reply-To: <20080603130709.fcf6a751.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031637.52992.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 04:07:09 pm Andrew Morton wrote:
> On Tue, 03 Jun 2008 20:52:18 +0100
>
> Nix <nix@esperi.org.uk> wrote:
> > On 3 Jun 2008, Daniel Hazelton said:
> > > On Tuesday 03 June 2008 03:32:11 pm Andrew Morton wrote:
> > >> On Tue, 3 Jun 2008 15:02:35 -0400
> > >>
> > >> Jeff Dike <jdike@addtoit.com> wrote:
> > >> > Protection against the host's time going backwards - keep track of
> > >> > the time at the last tick and if it's greater than the current time,
> > >> > keep time stopped until the host catches up.
> > >>
> > >> Strange.  What would cause the host's time (or at least UML's
> > >> perception of it) to go backwards?
> > >
> > > A wild guess would be that the UML process is running "fast" at some
> > > point and its expectation of the host's time is skewed forward because
> > > of that.
> >
> > Quite so. Simply running ntp on the host (in slew-only mode, no less!)
> > can cause this.
> >
> > > Another possibility is that the hosts clock got reset between the times
> > > UML has checked it and the correction was a negative one.
> >
> > That too.
>
> So if I change the host's time by an hour, the time will not advance at all
> on the guest for the next hour? Sounds suboptimal :)

I agree. But like I said originally - it's a wild guess. I don't even know how 
accurate it is. 

> I suppose the guest should be running an ntp client synced to something
> sane anyway?

That might be helpful :)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
