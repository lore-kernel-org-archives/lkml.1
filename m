Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539Ab0AZIqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0AZIqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973Ab0AZIqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:46:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43866 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0AZIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:46:50 -0500
Date: Tue, 26 Jan 2010 09:46:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/29] move acornfb's probe function to .devinit.text
Message-ID: <20100126084641.GB20792@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <1264278937-19675-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100123232813.GB4146@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100123232813.GB4146@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 01:25:58 +0200, Alexey Dobriyan wrote:
> gods, can you just send one patch for all framebuffer drivers?
Well, I thought one logical change per changeset is the favourite way to
go.  And as the people Cc:d are different I think most people prefer it
this way.

On Sun, Jan 24, 2010 at 01:28:13AM +0200, Alexey Dobriyan wrote:
> On Sat, Jan 23, 2010 at 09:35:09PM +0100, Uwe Kleine-König wrote:
> > -static int __init acornfb_probe(struct platform_device *dev)
> > +static int __devinit acornfb_probe(struct platform_device *dev)
> 
> Even more, if this function is marked __devinit, some other functions
> can very well be marked __devinit, can you do this?
Probably, the big pro after my patch is that modpost can warn about
this.  Actually this applies to all (initially) over 50 patches in this
series.  If you take my patches, squash them together and fix all called
functions, I'm happy, too.

If you don't I might come back to this and do it myself.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
