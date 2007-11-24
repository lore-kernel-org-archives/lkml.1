Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXKXT2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXKXT2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXKXT14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:27:56 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59366 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753036AbXKXT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:27:56 -0500
Date: Sat, 24 Nov 2007 20:24:59 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC 4/4] Atmel MCI: Driver for Atmel on-chip MMC controllers
Message-ID: <20071124202459.4780da17@siona>
In-Reply-To: <200711241048.39990.david-b@pacbell.net>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
	<20071124180023.20c831b8@poseidon.drzeus.cx>
	<20071124191648.2c2d56c7@siona>
	<200711241048.39990.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 10:48:39 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Saturday 24 November 2007, Haavard Skinnemoen wrote:
> > > 
> > > Why is this needed and is it perhaps something that can be moved
> > > to the MMC core?  
> > 
> > We used to have lots of problems with overruns and underruns and
> > those parameters were useful to limit the transfer rate. Now that
> > the RDPROOF and WRPROOF bits seem to have taken care of these
> > problems for good, I guess we can remove this parameter.  
> 
> Not all silicon *has* those bits though, right?  Like at91rm9200.

Right. The at91rm9200 doesn't have them, and I believe one of the
at91sam926x chips (at91sam9261?) doesn't have them. So if we're going to
merge this driver with at91_mci, I suppose it makes sense to keep this
parameter.

Haavard
