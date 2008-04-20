Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYDTShY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYDTShY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYDTShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:37:10 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:33805 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754535AbYDTShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:37:08 -0400
X-Originating-IP: [74.251.45.21]
Date: Sun, 20 Apr 2008 13:37:04 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Chris Snook <csnook@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080420133704.63f5cc10@osprey.hogchain.net>
In-Reply-To: <20080420122631.GA4761@martell.zuzino.mipt.ru>
References: <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com>
	<Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
	<20080414183221.GA5234@martell.zuzino.mipt.ru>
	<20080414195613.GA4772@martell.zuzino.mipt.ru>
	<Pine.LNX.4.64.0804141301580.7803@schroedinger.engr.sgi.com>
	<20080419111719.GA6724@martell.zuzino.mipt.ru>
	<20080419144535.GA4814@martell.zuzino.mipt.ru>
	<20080419215444.2d4623f5@osprey.hogchain.net>
	<20080420111453.GA4902@martell.zuzino.mipt.ru>
	<20080420060607.2b1be48b@osprey.hogchain.net>
	<20080420122631.GA4761@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 16:26:31 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Apr 20, 2008 at 06:06:07AM -0500, Jay Cliburn wrote:
> > On Sun, 20 Apr 2008 15:14:53 +0400
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Sat, Apr 19, 2008 at 09:54:44PM -0500, Jay Cliburn wrote:
> > > > On Sat, 19 Apr 2008 18:45:35 +0400
> > > > Alexey Dobriyan <adobriyan@gmail.com> wrote:
[...]
> > > > > So, it's enough to scp 200 MB git archive and immediately
> > > > > start rebooting sequence for horrors described above to
> > > > > appear. It's not 100% reproducible but more like 90%.
> > > > 
> > > > Do I understand correctly that these failures occur only while
> > > > the network interface is going down?
> > > 
> > > Yep. During up or running there were no problems with this card.
> > > 
> > 
> > One more question:  Does it happen whether or not you're using atl1
> > as a netconsole?
> 
> Without netconsole bugs happens too.
> 

I can't duplicate this error, but it's probably because my machine
doesn't have 4GB of memory.

I have one report in Febroary 2008 of another user encountering strange
oopses in 2.6.23.12 and 2.6.24 whenever he downed the interface.  I
suspect your experience is a repeat of that.

Just to be clear, you transfer about 200MB to the NIC (Rx direction),
then immediately reboot, right?  Can you duplicate the problem if you
simply ifconfig down instead of rebooting after the transfer?  

Thanks for your help.

Jay
