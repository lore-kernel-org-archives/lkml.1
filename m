Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYCTJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYCTJAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYCTJAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 05:00:17 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:55943 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYCTJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 05:00:14 -0400
Date: Thu, 20 Mar 2008 10:00:11 +0100
From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] [RFC] [IPv6] spelling fix in /proc:
	/proc/sys/net/ipv6/conf/default/temp_prefered_lft
Message-ID: <20080320090011.GK6935@ens-lyon.fr>
References: <20080319204227.GF6935@ens-lyon.fr> <20080319.135205.125229102.davem@davemloft.net> <1205976319.26345.20.camel@localhost> <20080319.185649.235399151.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319.185649.235399151.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 06:56:49PM -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Wed, 19 Mar 2008 18:25:19 -0700
> 
> > On Wed, 2008-03-19 at 13:52 -0700, David Miller wrote:
> > > From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> > > Date: Wed, 19 Mar 2008 21:42:27 +0100
> > > > Here is a patch to fix all the spelling error (prefered -> preferred)
> > > I think this doesn't add any value.
> > > If the procfs file name has to remain the same, which it does,
> > > changing variable and macro names to be different will only
> > > cause merge conflicts and pain yet have no redeeming value.
> > 
> > I disagree.  Proper spelling has value.
> 
> Only if it matches the spelling of thing it is implementing!
> 
> Making the object being implemented and the variables used to do so
> disagree in name will only create other kinds of confusion.

The file already have both occurences, there are function names and
variable with "preferred", sometimes mixed in the same line.

If it can help, the last time a line which uses prefered_lft was
changed, it was more than a year ago (1ab1457c42bc078e5a9becd82a7f9f940b55c53a)
for a whitespace cleanup.
Most of the occurences haven't been touched since the conversion to git.

regards,

Benoit

PS: I don't really care, it's just that I was touching the lifetime code
and tought that maybe I should try to change the whole file before
submitting my code.
-- 
:wq
