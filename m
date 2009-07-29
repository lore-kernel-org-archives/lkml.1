Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZG2O5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZG2O5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZG2O5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:57:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33347 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZG2O5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:57:20 -0400
Date: Wed, 29 Jul 2009 16:57:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, Troy Moure <twmoure@szypr.net>,
       Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
Message-ID: <20090729145702.GA1534@ucw.cz>
References: <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain> <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain> <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain> <alpine.LNX.1.10.0907221546480.26357@bizon.gios.gov.pl> <alpine.LFD.2.01.0907220846350.19335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907220846350.19335@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > > index 5c1a2c0..af4a15c 100644
> > > --- a/drivers/video/fbmon.c
> > > +++ b/drivers/video/fbmon.c
> > > @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
> > > 
> > > static int edid_checksum(unsigned char *edid)
> > > {
> > > -	unsigned char i, csum = 0, all_null = 0;
> > > -	int err = 0, fix = check_edid(edid);
> > > +	unsigned csum = 0, all_null = 0;
> > > +	int i, err = 0, fix = check_edid(edid);
> 
> I don't know where the 'char' disappeared, but that was obviously not 
> intended. I just meant to move the 'i' from one line to the other.
> 
> > > 
> > > 	if (fix)
> > > 		fix_edid(edid, fix);
> > 
> > Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> > 
> > On condition, that you keep "unsigned char" here. ;)
> 
> Indeed. I'll commit the fixed version. Thanks for testing and sorry for 
> the idiot patch.

So... we are going to just work around the gcc bug in the kernel?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
