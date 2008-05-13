Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbYEMRBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbYEMRBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760911AbYEMRBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:01:31 -0400
Received: from bar.sig21.net ([88.198.146.85]:43928 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760897AbYEMRBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:01:30 -0400
Date: Tue, 13 May 2008 19:01:16 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513170116.GA27978@linuxtv.org>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de> <20080513163647.GA21678@elte.hu> <20080513164140.GA21877@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513164140.GA21877@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-21-Score: -4.6 (----)
X-Spam-21-Report: No, score=-4.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.220,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:41:40PM +0200, Ingo Molnar wrote:
> 
> * Oliver Endriss <o.endriss@gmx.de> wrote:
> 
> > Sure. And without the patch you can simply add
> > - STANDALONE=y or
> > - DVB_AV7110_FIRMWARE=n
> > to your allrandom.config. ;-)
>  
> hm, you are right - i've added STANDALONE=y previously but it went 
> missing in action. So forget my patch, it was user error - the driver is 
> right in that it already depends on STANDALONE :-) I guess STANDALONE 
> should enable PREVENT_FIRMWARE_BUILD as well to avoid such errors ...

If you do _build_ testing you don't care if the driver
won't work because of missing firmware. With STANDALONE=y
you exclude drivers from build testing.

Johannes
