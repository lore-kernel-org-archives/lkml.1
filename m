Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYDERwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYDERwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 13:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYDERwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 13:52:41 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:49474 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYDERwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 13:52:40 -0400
Date: Sat, 5 Apr 2008 19:52:33 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 01/22] Generic show_mem() implementation
Message-ID: <20080405175233.GA4421@osiris.boeblingen.de.ibm.com>
References: <1207168839586-git-send-email-hannes@saeurebad.de> <20080403075545.GC4125@osiris.boeblingen.de.ibm.com> <20080403124820.GA30356@uranus.ravnborg.org> <871w5nouwp.fsf@saeurebad.de> <20080403181202.GA32319@uranus.ravnborg.org> <87prt6muux.fsf@saeurebad.de> <20080404213540.GA15535@uranus.ravnborg.org> <87d4p5kyhj.fsf@saeurebad.de> <20080405075108.GA6730@osiris.boeblingen.de.ibm.com> <20080405090403.GA24316@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080405090403.GA24316@linux-mips.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2008 at 10:04:03AM +0100, Ralf Baechle wrote:
> On Sat, Apr 05, 2008 at 09:51:08AM +0200, Heiko Carstens wrote:
> 
> > But you can solve this problem with no ifdefs and config options at all,
> > since you may as well just use __attribute__((weak)) for the generic
> > implementation.
> 
> Which may result in the version of the function getting linked in but
> staying unreferenced.

Oh, I assumed ld would support -dead_strip in the meantime to get rid of
unreferenced functions. Looks like it still doesn't.
