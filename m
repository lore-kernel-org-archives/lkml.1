Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbYBZS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbYBZS5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbYBZS5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:57:17 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759139AbYBZS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:57:16 -0500
Date: Tue, 26 Feb 2008 10:56:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
 in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-Id: <20080226105606.e56e4ec6.akpm@linux-foundation.org>
In-Reply-To: <20080226181611.GB6030@elf.ucw.cz>
References: <20080225143932.6b83b65d.akpm@linux-foundation.org>
	<8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com>
	<20080225145347.a61f6c61.akpm@linux-foundation.org>
	<20080225225820.GP2659@elf.ucw.cz>
	<20080225155550.4a020dfb.akpm@linux-foundation.org>
	<20080226000007.GB22102@atrey.karlin.mff.cuni.cz>
	<20080226101117.GA26671@atrey.karlin.mff.cuni.cz>
	<20080226174613.GA26259@codemonkey.org.uk>
	<20080226175954.GA5707@elf.ucw.cz>
	<20080226181001.GA7714@codemonkey.org.uk>
	<20080226181611.GB6030@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 19:16:11 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> On Tue 2008-02-26 13:10:01, Dave Jones wrote:
> > On Tue, Feb 26, 2008 at 06:59:54PM +0100, Pavel Machek wrote:
> >  
> >  > > if by 'custom' you mean the solution everyone agreed to work
> >  > > toward at the power management summit several years ago
> >  > > (hal/pm-utils) then, yes.
> >  > 
> >  > I must have been on different summit... I believe it is bad to tie
> >  > s2ram to hal, because it makes testing on minimal system hard.
> >  > 
> >  > Anyway, what is the "default" way to trigger s2ram for Andrew? Perhaps
> >  > Fedora already has his machine whitelisted...
> > 
> > There is no s2ram. pm-suspend uses the white/black-lists in pm-utils.
> > Remember that? The cross-distro package everyone agreed was a good idea
> > so that every distro didn't have their own magic utility ?
> 
> Well, we have cross-distro package, it is at suspend.sf.net , and it
> can bring up video - which is kind of important. (It is single binary,
> so it can be pagelocked -- which is important for s2disk).
> 
> Plus it does not depend on HAL.

Meanwhile, my computer continues to not work.

First thing we need to do is to work out why it won't stay suspended?
