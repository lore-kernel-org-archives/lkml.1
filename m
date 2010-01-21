Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915Ab0AUQBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0AUQBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717Ab0AUQBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:01:00 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:54482 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0AUQA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:00:59 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 11:00:59 EST
X-Spam-Processed: digidescorp.com, Thu, 21 Jan 2010 09:51:40 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1637e7ab51=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
Subject: Re: Generic DMA - BUG_ON
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20100120110031.GD8665@amd.com>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
	 <20100120105350.GA23394@flint.arm.linux.org.uk>
	 <20100120110031.GD8665@amd.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Thu, 21 Jan 2010 09:51:37 -0600
Message-Id: <1264089097.18869.0.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 12:00 +0100, Joerg Roedel wrote:
> On Wed, Jan 20, 2010 at 10:53:50AM +0000, Russell King wrote:
> > and ops is NULL, then this code will oops; you will get a full register
> > dump and backtrace.  You can use this information along with markup_oops.pl
> > to find out where the problem is.
> 
> You can't rely on the oops if the code runs in process context. The
> process may have address 0 mapped which would result in a security hole.
> We had two of these bugs last year.

You also can't rely on an oops in a NOMMU environment.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



