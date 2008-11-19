Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYKSSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYKSSD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYKSSDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:03:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38529 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYKSSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:03:12 -0500
Date: Wed, 19 Nov 2008 12:28:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       kaszak@gmail.com, lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081119112823.GD21876@elf.ucw.cz>
References: <20081001123656.GA30942@elf.ucw.cz> <20081001125248.GA29661@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001125248.GA29661@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-01 08:52:48, Christoph Hellwig wrote:
> On Wed, Oct 01, 2008 at 02:36:56PM +0200, Pavel Machek wrote:
> > +source "drivers/net/wireless/winbond/Kconfig"
> 
> winbond is a little too generic, please use the same name as the driver
> name for the directory.
> 
> > @@ -0,0 +1,6 @@
> > +config W35UND
> > +	tristate "Winbond driver"
> > +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL && !4KSTACKS
> > +	---help---
> > +	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
> > +	  Check http://code.google.com/p/winbondport/ for new version
> 
> Again, please give the option a useful name, and a useful description
> including mentioning the actual chip name in there.
> 
> Also the !4KSTACKS dependency looks rather odd.

Fixed now, will sent patch shortly.

> No comments on the code now, I don't think I want to look at it..

No, you don't want to :-).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
