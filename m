Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYJUNd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYJUNd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJUNdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:33:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44486 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751167AbYJUNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:33:18 -0400
Date: Tue, 21 Oct 2008 15:33:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use PC-BIOS NUMLOCK flag
Message-ID: <20081021133304.GB9617@ucw.cz>
References: <alpine.LSU.0.999.0810161358540.5404@be1.lrz> <20081016143856.GD5071@const.bordeaux.inria.fr> <alpine.LSU.0.999.0810161958450.5051@be1.lrz> <20081016191106.GB4988@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081016191106.GB4988@const.famille.thibault.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-16 21:11:06, Samuel Thibault wrote:
> Bodo Eggert, le Thu 16 Oct 2008 20:00:31 +0200, a écrit :
> > On Thu, 16 Oct 2008, Samuel Thibault wrote:
> > > Bodo Eggert, le Thu 16 Oct 2008 13:59:49 +0200, a écrit :
> > 
> > > > +	  If you have an alternative firmware like OpenFirmware or LinuxBios,
> > > > +	  this flag might not be set correctly, which results in a random state
> > > > +	  of the Numlock key.
> > > 
> > > That's an issue. That means that distributions will just not enable,
> > > and thus the flag is not really useful, since people who would
> > > compile their own kernel would very likely have already setup their
> > > initialization scripts into calling setleds +num (or just set LEDS=+num
> > > in /etc/console-tools/config on a debian machine).
> > 
> > I hope somebody will pop up and say "Hey, those will create an IBM PC data 
> > area, because they run DOS" ...
> 
> Mmm, or rather "hey, here are the patches to fix those BIOSes" :)

Broken bioses being around should not penalize working bioses. Patch
looks good to me. Yes, I consider LinuxBios broken in this regard.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
