Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXHNHzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXHNHzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXHNHzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:55:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:29174 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbXHNHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nKgx2YkT+Japl8C6vgrGs7J6FDGs+hhGl63Racvwkw4MfdYvoC94iq5EQ58kjro+oW7nMY0KU6WnrBOO4ULDBCT/qmcFcmwlTRQOKzBklxiuPQ0wCowYW0uzg/JHbhO/97uqEnE6dtZZZvTViOIDpEbTO6/245lyj5anduBo/RU=
Date: Tue, 14 Aug 2007 11:54:51 +0400
From: Sergey Dolgov <solkaa@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>, Sergey Dolgov <solkaa@gmail.com>,
       Len Brown <len.brown@intel.com>, Norbert Preining <preining@logic.at>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3 regression and bisection query
Message-ID: <20070814075422.GA2586@slk.laptop>
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com> <20070813212204.GA2645@slk.laptop> <46C0D6DB.7090703@suse.de> <Pine.LNX.4.64.0708132353480.6269@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708132353480.6269@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 11:56:22PM +0100, Hugh Dickins wrote:
> On Tue, 14 Aug 2007, Alexey Starikovskiy wrote:
> > Sergey Dolgov wrote:
> > > On Mon, Aug 13, 2007 at 07:44:48PM +0100, Hugh Dickins wrote:
> > >   
> > >> Git bisection (with manual fixups to i386 mmiocfg horror, thanks
> > >> for drawing attention to that in your changelog) accuses Alexey's
> > >> ACPI: EC: If ECDT is not found, look up EC in DSDT
> > >> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> > >> and if I revert that along with Len's subsequent
> > >> ACPI: EC: fix build warning
> > >> 52fe4bdf40bc07498c5f7935551774e8f8458190
> > >> then I have Fn-F4 suspending to RAM again.
> > >
> > > I've also noticed a regression since -rc2 in battery status reporting
> > > on my HP nx7300 laptop: the output of
> > >
> > >     cat /proc/acpi/battery/C1BE/state
> > >
> > > does not change after this file has been read for the the first time;
> > > for exaple, the line "charging state: charged" does not change to
> > > "charging state: discharging" upon unplugging the power cord.
> > >
> > > Reverting the above 2 commits fixes this issue for me.
> > >
> > > --
> > > Sergey
> > >   
> > Function to register query methods (means by which EC talks to ACPI)
> > was deleted by mistake.
> > 
> > Could you please try the attached patch?
> 
> Great, that indeed fixes my Thinkpad suspend-to-RAM cases
> (both the Fn-F4, and resume from echo mem >/sys/power/state):
> thanks a lot, Alexey.

Same thing here, your patch ontop of -rc3 fixes battery status
reporting for me.

Thanks, Alexey.

--
Sergey
