Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbYEMPYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbYEMPYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYEMPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:24:11 -0400
Received: from bar.sig21.net ([88.198.146.85]:49995 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYEMPYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:24:10 -0400
Date: Tue, 13 May 2008 17:23:59 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513152359.GA26952@linuxtv.org>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805131633.55469@orion.escape-edv.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-21-Score: -4.4 (----)
X-Spam-21-Report: No, score=-4.4 required=5.0 tests=ALL_TRUSTED=-1.8,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:33:54PM +0200, Oliver Endriss wrote:
> Johannes Stezenbach wrote:
> > You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.
> 
> Sure. And without the patch you can simply add
> - STANDALONE=y or
> - DVB_AV7110_FIRMWARE=n
> to your allrandom.config. ;-)

It is desirable to have one generic "don't break the build
because of missing firmware binaries" option, isn't it?

Johannes
