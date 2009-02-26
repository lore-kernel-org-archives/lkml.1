Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbZBZV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbZBZV6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZBZV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:58:13 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:55425 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZBZV6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:58:12 -0500
Subject: Re: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200902261328.41910.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	 <200902261148.36892.david-b@pacbell.net>
	 <1235681638.31223.57.camel@vega.slimlogic.co.uk>
	 <200902261328.41910.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 21:58:08 +0000
Message-Id: <1235685488.31223.104.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 13:28 -0800, David Brownell wrote:
> On Thursday 26 February 2009, Liam Girdwood wrote:
> > Applied with git-am merge conflicts. It builds ok, can you check against
> > your tree.
> 
> What were the conflicts -- just offsets?
> 
> Your "-next" regulator tree seems to be missing a doc patch
> you had asked for, maybe that's an issue.
> 
> - Dave
> 
> =========== CUT HERE
> From: David Brownell <dbrownell@users.sourceforge.net>
> Subject: regulator: get_status() grows kerneldoc
> 
> Add kerneldoc for the new get_status() message.  Fix the existing
> kerneldoc for that struct in two ways:
> 
>  (a) Syntax, making sure parameter descriptions immediately
>      follow the one-line struct description and that the first
>      blank lines is before any more expansive description;
>  (b) Presentation for a few points, to highlight the fact that
>      the previous "get" methods exist only to report the current
>      configuration, not to display actual status.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/linux/regulator/driver.h |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

Thanks.

Fixed.

Liam

