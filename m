Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYBXHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYBXHzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYBXHzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:55:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4540 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751737AbYBXHzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:55:38 -0500
Date: Sat, 23 Feb 2008 22:01:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Message-ID: <20080223210146.GB4340@ucw.cz>
References: <20080218002815.GA4612@dose.home.local> <20080218194904.GA7115@elf.ucw.cz> <20080219085222.GA5328@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219085222.GA5328@dose.home.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-19 09:52:22, Tino Keitel wrote:
> On Mon, Feb 18, 2008 at 20:49:04 +0100, Pavel Machek wrote:
> > On Mon 2008-02-18 01:28:15, Tino Keitel wrote:
> > > Hi folks,
> > > 
> > > with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> > > message on the console is "Suspending console(s)". I also tried some
> > > other versions after 2.6.24, all of them fail with this hang.
> > 
> > Try adding 'no_console_suspend' to kernel command line.
> 
> Thanks, that gave a bit insight. The last message is now:
> 
> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> 
> This is my graphics card:
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
> 945GM/GMS, 943/940GML Express Integrated Graphics Controller
> 
> So it looks like the recent changes that should repair console
> sudpend/resume for Intel graphics broke suspend for me.

Can you bisect (if it worked before) or add printks to see where it
fails?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
