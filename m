Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYEZVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYEZVxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYEZVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:53:09 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:37760 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbYEZVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:53:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=msguZg9Gwqa94ulLX9MytDv8f0WRs/narpsIBL/9W7EP+D1igPIKeygn1QMtnOcd;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Mon, 26 May 2008 17:52:27 -0400
From: Bill Fink <billfink@mindspring.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Theodore Tso <tytso@MIT.EDU>, Glen Turner <gdt@gdt.id.au>,
       Chris Peterson <cpeterso@cpeterso.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jeff Garzik <jeff@garzik.org>, "Kok\, Auke" <auke-jan.h.kok@intel.com>,
       Rick Jones <rick.jones2@hp.com>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
Message-Id: <20080526175227.4b7ae764.billfink@mindspring.com>
In-Reply-To: <m38wxwepvt.fsf@maximus.localdomain>
References: <482C7E53.3050300@hp.com>
	<482C8184.2030906@garzik.org>
	<482C8550.5000909@intel.com>
	<482C8D4D.3040702@garzik.org>
	<20080516132107.GA11304@csclub.uwaterloo.ca>
	<20080516161029.44ded734@core>
	<20080516173610.GA27126@csclub.uwaterloo.ca>
	<20080516191125.46f59ad6@core>
	<a24804730805162155m72e6b40aweb8822515c880c50@mail.gmail.com>
	<1211728189.5913.71.camel@andromache>
	<20080525232712.GF5970@mit.edu>
	<20080526154326.1fe44214@Varda>
	<20080526111458.fff6c311.billfink@mindspring.com>
	<m38wxwepvt.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4de6254de8c47e34468389a8f3aae996f2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Krzysztof Halasa wrote:

> Bill Fink <billfink@mindspring.com> writes:
> 
> > Another idea that occured to me:  How about using the low order bits
> > of the instruction memory address being executed that was interrupted
> > by the HZ timer interrupt.
> 
> Think of constant-instructions-length processors :-)

I'm not sure what you're driving at, but if it's that you shouldn't
use the very last 2 or 3 bits, then sure those should be excluded.
But that still leaves 9 or 10 bits at least in the page offset, and
that's being conservative in the number of address bits to sample.

						-Bill
