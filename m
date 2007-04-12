Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXDLOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXDLOSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXDLOSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:18:21 -0400
Received: from mx3.mail.ru ([194.67.23.149]:4016 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbXDLOSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:18:20 -0400
Date: Thu, 12 Apr 2007 18:15:05 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412141505.GA25552@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070412130817.GA29900@srcf.ucam.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:08:18PM +0100, Matthew Garrett wrote:
> On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> > + * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> > + * tenths of a degree unless otherwise stated. It's driver's job to convert
> > + * its raw values to which this class operates. If for some reason driver
> > + * can't afford this requirement, then it have to create its own attributes,
> > + * plus additional "XYZ_units" for each of them.
> 
> ACPI batteries can report capacity and rate in either mA or mW. Given

You sure, capacity in mA? Then I don't know. But you can safely
fallback and create your own attribute (just as in David's battery class,
where every battery required to create its own attributes), plus create
capacity_units attribute. So, user space will know your driver's specific
units.

> the lack of a constant voltage, how do you accurately convert between 
> the two? Right now, I think this is a loss of functionality over the 
> current situation.


> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
