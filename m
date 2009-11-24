Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZKXJwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZKXJwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932495AbZKXJwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:52:54 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:58808 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbZKXJwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:52:53 -0500
Message-ID: <4B0BACFA.90801@ladisch.de>
Date: Tue, 24 Nov 2009 10:52:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Monty Montgomery <xiphmont@gmail.com>,
       Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>	 <4B0BA71B.8040800@ladisch.de> <1259055721.29729.277.camel@macbook.infradead.org>
In-Reply-To: <1259055721.29729.277.camel@macbook.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Where did the new firmware come from?

Sorry, I snipped that part of Monty's mail:
> > This problem can be traced to the
> > linux/firmware/emi62/bistream.HEX file, which is loading different
> > FPGA firmware as compared to the driver pre-2.6.27.  In fact, it is
> > loading an exact copy of the bistream firmware file that belongs to
> > the emi26 driver rather than the firmware that previously belonged to
> > the emi62. A new firmware/emi62/bitstream.HEX file generated from the
> > old driver's header corrects the problem and the 6|2 works as it did
> > before.
> > 
> > Note that the current firmware/emi62/bitstream.HEX mistakenly
> > identifies itself as:
> > 
> > // VERSION= 1.0.0.191
> > // DATE= 2002oct28
> > 
> > ...this is incorrect and apparently cut out of the old emi62 driver's
> > firmware header and pasted onto the other firmware file.
