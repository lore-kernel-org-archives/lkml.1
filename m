Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbYANRh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbYANRh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYANRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:37:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:5324 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYANRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:37:50 -0500
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
From: Daniel Walker <dwalker@mvista.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20080114171736.GC19327@shadowen.org>
References: <47872E35.3070705@gmail.com>
	 <1200043035.29897.62.camel@imap.mvista.com> <47873505.7040008@gmail.com>
	 <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>
	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>
	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
	 <20080114171736.GC19327@shadowen.org>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 09:35:15 -0800
Message-Id: <1200332116.31521.3.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 17:17 +0000, Andy Whitcroft wrote:
> On Fri, Jan 11, 2008 at 06:06:35PM +0100, Stefan Richter wrote:
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Acked-by: Jiri Slaby <jirislaby@gmail.com>
> 
> As an absolute minimum this seems reasonable to me.  I guess we could
> make no arguments default to '-' also.  There are up and downsides to
> doing that, as currently no arguments currently tell you the usage and
> with this patch would point clearly out the '-' option.  Just assuming
> stding would lose easy access to usage, which may actually be more
> confusing for the beginner.  Hmmm.  Cirtainly will include this
> documentation change if nothing else.
> 

The patch that I submitted checks STDIN for piped data, and if there is
any it will default to checking that incoming data .. That's regardless
of the number of arguments given .. 

Daniel

