Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYIHN5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYIHN5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYIHN4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:56:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYIHN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:56:53 -0400
Date: Mon, 8 Sep 2008 16:00:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Tony Vroon <tony@vroon.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Message-ID: <20080908140027.GI26079@one.firstfloor.org>
References: <1220754742.8530.12.camel@localhost> <87abeivrdf.fsf@basil.nowhere.org> <20080908135558.GA31784@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908135558.GA31784@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 03:55:58PM +0200, Pavel Machek wrote:
> On Mon 2008-09-08 12:55:40, Andi Kleen wrote:
> > Tony Vroon <tony@vroon.org> writes:
> > 
> > > HARDWARE ERROR. This is *NOT* a software problem!
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Please contact your hardware vendor
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > > I realize that the linux kernel may be entirely blameless in this
> > > situation,
> > 
> > It is, like mcelog told you.
> 
> Ugh, actually this is not right. AFAIK MCEs can be triggered by stuff
> like PCI aborts, which in turn can be caused by software.

PCI aborts don't normally cause machine checks, no.

-Andi
-- 
ak@linux.intel.com
