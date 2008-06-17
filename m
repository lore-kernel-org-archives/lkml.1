Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYFQOQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYFQOQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYFQOPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:15:53 -0400
Received: from isilmar.linta.de ([213.133.102.198]:36710 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754986AbYFQOPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:15:52 -0400
Date: Tue, 17 Jun 2008 16:15:50 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Komuro <komurojun-mbn@nifty.com>, Jeff Garzik <jeff@garzik.org>,
       jgarzik@redhat.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme III 8GB
Message-ID: <20080617141549.GA490@isilmar.linta.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Komuro <komurojun-mbn@nifty.com>, Jeff Garzik <jeff@garzik.org>,
	jgarzik@redhat.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pcmcia <linux-pcmcia@lists.infradead.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20080607223716.7d142072.komurojun-mbn@nifty.com> <20080611072029.GB28692@comet.dominikbrodowski.net> <20080614120055.ad8fbee0.komurojun-mbn@nifty.com> <48537149.4040102@garzik.org> <20080614213612.96873c25.komurojun-mbn@nifty.com> <4855D8E2.10409@gmail.com> <20080616221145.e3b069b9.komurojun-mbn@nifty.com> <485669A0.6000404@gmail.com> <20080617212345.c452d8c5.komurojun-mbn@nifty.com> <4857C590.6050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4857C590.6050002@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 11:09:20PM +0900, Tejun Heo wrote:
> Okay.  The exit is from CS_CHECK macro on GetNextTuple, missed that
> macro. It means it failed to request IO resource somewhere.  Can you
> please try the attached patch?  It will show us where it failed.
> 
> This part of code hasn't changed at all in pata_pcmcia && I don't really
> understand the tuple business.  We need pcmcia people to pitch in.

The strange thing is that neither the PCMCIA side nor pata_pcmcia changed
between the working 2.6.26-rc4 and the non-working 2.6.26-rc3... that's why
I am at least as surprised as you are ;)

Thanks,
	Dominik
