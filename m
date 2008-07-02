Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYGBDLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYGBDLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYGBDL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:11:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:18730 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYGBDLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tCjXsZaJxPpUZsn7eMjYgP8aLquIAj9RyIymaF1dEhDHqYqmdWgtaCk6oBKxHrS8oW
         5KZ73WdX8co3bYo6a/wG/VUNNtdM/Ki6HLO2RpT6DbL5QgJYC9nbnbAnNXDnDwRnYpM8
         iuivuqeLw+Hosmjz9rDlGrOsMovMwmOgnHoYc=
Date: Tue, 1 Jul 2008 23:11:12 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: inux-next 0701 mv643xx_eth powerpc build failure
Message-ID: <20080702031111.GA26752@nineveh.local>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:14:34AM +1000, Stephen Rothwell wrote:

[next-20080701]

I'm getting a build failure on 32bit powerpc in -next, but not in mainline:

drivers/net/mv643xx_eth.c: In function 'mv643xx_eth_netpoll':
drivers/net/mv643xx_eth.c:2115: error: 'INT_CAUSE_EXT' undeclared
(first use in this function)
drivers/net/mv643xx_eth.c:2115: error: (Each undeclared identifier is
reported only once
drivers/net/mv643xx_eth.c:2115: error: for each function it appears in.)

I haven't investigated any further than a quick check if this hardware
even makes sense on 32bit powerpc -- it seems it does.  For now, I'm
just going to punt this and go to bed.  :-)

--
Joseph Fannin
jfannin@gmail.com
