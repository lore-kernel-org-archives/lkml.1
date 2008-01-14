Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYANTMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYANTMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYANTL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:11:59 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4179 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYANTL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:11:58 -0500
Date: Mon, 14 Jan 2008 19:12:43 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
Message-ID: <20080114191243.GB25058@shadowen.org>
References: <47873505.7040008@gmail.com> <1200043399.3905.9.camel@gimli.at.home> <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com> <1200044206.29897.73.camel@imap.mvista.com> <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com> <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de> <20080114171736.GC19327@shadowen.org> <1200332116.31521.3.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200332116.31521.3.camel@imap.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:35:15AM -0800, Daniel Walker wrote:
> 
> On Mon, 2008-01-14 at 17:17 +0000, Andy Whitcroft wrote:
> > On Fri, Jan 11, 2008 at 06:06:35PM +0100, Stefan Richter wrote:
> > > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > > Acked-by: Jiri Slaby <jirislaby@gmail.com>
> > 
> > As an absolute minimum this seems reasonable to me.  I guess we could
> > make no arguments default to '-' also.  There are up and downsides to
> > doing that, as currently no arguments currently tell you the usage and
> > with this patch would point clearly out the '-' option.  Just assuming
> > stding would lose easy access to usage, which may actually be more
> > confusing for the beginner.  Hmmm.  Cirtainly will include this
> > documentation change if nothing else.
> > 
> 
> The patch that I submitted checks STDIN for piped data, and if there is
> any it will default to checking that incoming data .. That's regardless
> of the number of arguments given .. 

So it does, however that of itself differs from the unix norm; as with
this I cannot run checkpatch and "type" (ie paste) a patch fragment to
check it.  So I don't think we want the semantics as you have there,
as its confusing to the experienced user and inconsistent with the norm.
Either we should document the standard '-' usage as has been suggested
elsewhere or always assume stdin with no parameters.

-apw
