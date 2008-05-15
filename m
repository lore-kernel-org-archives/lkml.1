Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbYEOXhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbYEOXhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbYEOXgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:36:53 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34205 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754585AbYEOXgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:36:52 -0400
Date: Thu, 15 May 2008 19:36:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeff Garzik <jeff@garzik.org>, Chris Peterson <cpeterso@cpeterso.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080515233642.GT18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Jeff Garzik <jeff@garzik.org>,
	Chris Peterson <cpeterso@cpeterso.com>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Rick Jones <rick.jones2@hp.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com> <20080515214721.GP18825@mit.edu> <482CB1FB.7080807@garzik.org> <20080515222941.GB20976@khazad-dum.debian.net> <482CBCC6.6010905@garzik.org> <20080515230221.GC20976@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515230221.GC20976@khazad-dum.debian.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 08:02:21PM -0300, Henrique de Moraes Holschuh wrote:
> I will tell you what.  If someone manages to get trousers to actually
> *work* for data binding and sealing to the TPM in a ThinkPad T43 with an
> NSC/Winbond TPM (their "sup3r s3kr1t TPM-inside-the-SuperIO 8394T" crap
> one needs a NDA to get the documentation for), and I manage to duplicate
> it (i.e. make it work here too), I will write the rng-tools trousers
> interface code (at least for the Debian version) :-)
> 
> The kernel TPM driver works, the BIOS works, and I have the PCRs updated
> properly during boot, but trousers get the tpm pubek key wrong for some
> reason (the kernel driver can read it just fine).  The chip is good,
> IBM's stuff worked just fine with it.

There were some web pages on this subject that seemed imply that IBM
used a non-standard string-to-key algorithm, and that caused the
incompatibility with Trousers.  So if you initialized the TPM using
the IBM Windows drivers, you have to mess around with TSS to get it to
work correctly with Thinkpads.  I tried for a bit to try to get it to
work a while ago, but the few things I tried didn't work, and I
eventually lost interest.

							- Ted
