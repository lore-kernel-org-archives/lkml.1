Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYEOXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYEOXdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYEOXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:33:24 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34197 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011AbYEOXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:33:23 -0400
Date: Thu, 15 May 2008 19:33:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Chris Peterson <cpeterso@cpeterso.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080515233305.GS18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Chris Peterson <cpeterso@cpeterso.com>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Rick Jones <rick.jones2@hp.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com> <20080515214721.GP18825@mit.edu> <482CB1FB.7080807@garzik.org> <20080515222941.GB20976@khazad-dum.debian.net> <482CBCC6.6010905@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CBCC6.6010905@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:44:22PM -0400, Jeff Garzik wrote:
>
> Neat.  I always did prefer VIA padlock in userspace.
>
> I just sorta assumed a buffering, interrupt-driver TPM RNG driver would be 
> better than doing it from userspace, but maybe that was a bad assumption to 
> make on my part.  It should be quite doable to support TPM RNG entirely via 
> userspace, at any rate.

If I recall correctly, you need access to a magic TPM key just to
*talk* to the TPM.  Normally that key is stored in a file, and of
course we can have a userspace helper pull that key into the kernel,
but given the extensive Trousers infrastructure that can do this
already, it seemed to make more sense to do it all in userspace, and
not require any more kernel code.

						- Ted
