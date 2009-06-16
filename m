Return-Path: <linux-kernel-owner+w=401wt.eu-S1763702AbZFPU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763702AbZFPU4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbZFPU4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:56:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761084AbZFPU4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:56:38 -0400
Date: Tue, 16 Jun 2009 13:51:21 -0700
From: Greg KH <gregkh@suse.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>, Gianluca Palli <gpalli@deis.unibo.it>,
       David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb
	based cards
Message-ID: <20090616205121.GB2810@suse.de>
References: <200906161701.45234.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906161701.45234.herton@mandriva.com.br>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 05:01:44PM -0300, Herton Ronaldo Krzesinski wrote:
> Hi,
> 
> The s626 (comedi) driver in staging conflicts with philips SAA7146 media/dvb
> based cards, because it claims the same vendor:device pci id for all 
> subdevice/subvendor ids. What happens is that for people that have a philips 
> SAA7146 based card, s626 if available gets loaded by udev and makes system 
> freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).

So a PCI device that does different things has the same device ids?
ick, stupid vendors...

> Looks like s626 shouldn't claim all 1131:7146 devices, either by specifying 
> specific subdevice/subvendor ids specific to s626 devices or doing additional 
> checks in its probe/attach function.

If you can propose the proper sub ids, or the needed checks, please send
a patch.

thanks,

greg k-h
