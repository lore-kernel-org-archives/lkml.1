Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXJ1By5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXJ1By5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 21:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXJ1Byu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 21:54:50 -0400
Received: from lixom.net ([66.141.50.11]:37447 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXJ1Byu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 21:54:50 -0400
Date: Sat, 27 Oct 2007 21:02:38 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [POWERPC] Fix CONFIG_SMP=n build break
Message-ID: <20071028020238.GA30892@lixom.net>
References: <20071026165510.GA2323@lixom.net> <200710262019.12094.arnd@arndb.de> <20071027172851.GA11930@lixom.net> <20071028123850.e5b9c555.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028123850.e5b9c555.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 12:38:50PM +1100, Stephen Rothwell wrote:
> Hi Olof,
> 
> Just a trivial thing ...
> 
> On Sat, 27 Oct 2007 12:28:51 -0500 Olof Johansson <olof@lixom.net> wrote:
> >
> > +u8 iic_get_target_id(int cpu)
> > +{
> > +	return per_cpu(iic, cpu).target_id;
> > +}
> > +
> > +EXPORT_SYMBOL_GPL(iic_get_target_id);
> 
> We don't normally put a blank line between a function and its EXPORT...

Yeah, sloppy of me, I thought I just copied and pasted. Paulus: feel
free to fix up before applying.


Thanks for your feedback,

-Olof
