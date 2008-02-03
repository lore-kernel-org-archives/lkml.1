Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYBCStf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYBCStf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYBCSt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:49:27 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44913 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYBCSt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:49:27 -0500
Date: Sun, 3 Feb 2008 19:49:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203184931.GA2648@uranus.ravnborg.org>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203181648.GA1629@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 07:16:48PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > 
> > 
> > Do you have an updated version or is this the latest one?
> 
> I'm glad you ask ;-). Here's reasonably-recent version (I have
> slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> eventually got it to work on 64-bit, by reusing trampoline.S code.
> 
> 								Pavel
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Hi PAvel.

Before you submit this for real we need me to take a deper
look into your Makefiles.
We do not want this duplication between boot and acpi.
And the way you deal with code sharing from boot/ is not
OK either.

But I do have a few other things pending before I have time
so please ping me in a week or two.

	Sam
