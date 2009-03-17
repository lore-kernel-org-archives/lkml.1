Return-Path: <linux-kernel-owner+w=401wt.eu-S1763388AbZCQLnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763388AbZCQLnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZCQLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:43:15 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:51324 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZCQLnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:43:15 -0400
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: David Brownell <david-b@pacbell.net>, Mark Brown <broonie@sirena.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
In-Reply-To: <49BF52F9.2030708@nokia.com>
References: <49B11EB0.30809@nokia.com>
	 <200903061116.21544.david-b@pacbell.net>
	 <20090306221842.GB15728@sirena.org.uk>
	 <200903061448.43749.david-b@pacbell.net>
	 <1236599245.6781.86.camel@vega.slimlogic.co.uk>
	 <49BF52F9.2030708@nokia.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 11:43:09 +0000
Message-Id: <1237290190.6781.313.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 09:36 +0200, Adrian Hunter wrote:
> Liam Girdwood wrote:
> > On Fri, 2009-03-06 at 14:48 -0800, David Brownell wrote:
> >> On Friday 06 March 2009, Mark Brown wrote:
> >>> Would it make sense to make this platform data so that if a given board
> >>> requires running the chip like this it can be enabled for those boards
> >>> but it's not something people might turn on because it seems useful?
> >> Let's hear if it's actually needed, first.  :)
> >>
> >> I coded those tables so that it would be easy to kick in the
> >> support for out-of-spec operation if it's really needed.  But
> >> so far we don't know that it's needed, and I'd rather it not
> >> be too easy to run like that.
> >>
> > 
> > I've now reverted this patch. 
> 
> TI say we can use VAUX3 at 3V and expect no problems:
> 
> http://community.ti.com/forums/p/3777/14574.aspx
> 
> So how do we do it?

I'd prefer seeing the reply from Ghandar to David's last question before
accepting this patch again. It's still not 100% clear from TI, things
seem a little bit muddled as to whether 3V will be guaranteed to work on
*all* shipped devices.

Thanks

Liam

