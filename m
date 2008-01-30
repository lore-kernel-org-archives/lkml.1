Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYA3N21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYA3N21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYA3N2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:28:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbYA3N2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:28:17 -0500
Date: Wed, 30 Jan 2008 14:28:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-ID: <20080130132833.GA5139@elf.ucw.cz>
References: <20080128171929.GA3906@ds.suse.cz> <20080128175357.GA1990@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128175357.GA1990@martell.zuzino.mipt.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-01-28 20:53:57, Alexey Dobriyan wrote:
> On Mon, Jan 28, 2008 at 06:19:29PM +0100, David Sterba wrote:
> > ipwireless: driver for PC Card, 3G internet connection
> 
> > +struct nl_first_paket_header {
> > +#if defined(__BIG_ENDIAN)
> > +	unsigned char packet_rank:2;
> > +	unsigned char address:3;
> > +	unsigned char protocol:3;
> > +#else
> > +	unsigned char protocol:3;
> > +	unsigned char address:3;
> > +	unsigned char packet_rank:2;
> > +#endif
> > +	unsigned char length_lsb;
> > +	unsigned char length_msb;
> > +};
> > +
> > +struct nl_packet_header {
> > +#if defined(__BIG_ENDIAN)
> > +	unsigned char packet_rank:2;
> > +	unsigned char address:3;
> > +	unsigned char protocol:3;
> > +#else
> > +	unsigned char protocol:3;
> > +	unsigned char address:3;
> > +	unsigned char packet_rank:2;
> > +#endif
> > +};
> 
> You want __BIG_ENDIAN_BITFIELD here.

Actually, you probably want to avoid bitfields here, and just do bit
arithmetics by hand.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
