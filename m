Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYHaLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYHaLES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbYHaLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 07:04:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33385 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbYHaLED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 07:04:03 -0400
Date: Sun, 31 Aug 2008 14:04:00 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Ambroz <comp@gjh.sk>, linux kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Marvell 6145 PATA controller
Message-ID: <20080831110400.GT16680@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Ambroz <comp@gjh.sk>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org
References: <48B9DCBE.3000306@gjh.sk> <20080831103608.69499247@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080831103608.69499247@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 10:36:08AM +0100, Alan Cox wrote:
> > The second solution is to remove few lines from ahci.c which lists the 
> > marvell 6145 device (and probably also marvell 6121).
> > Short patch included below.
> 
> Yes. I know or to teach the AHCI driver how to drive the PATA part of the
> device. Unfortunately I've been trying - privately and now publically to
> get Jeff Garzik to fix that one for *months*.

I don't think this issue is on the regression list. Maybe getting it
there would get some results.

BTW would it be possible for the ahci driver to determine if the PATA
ports are used and fail the probe in case they are?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
