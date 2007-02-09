Return-Path: <linux-kernel-owner+w=401wt.eu-S1946555AbXBIQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946555AbXBIQC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946556AbXBIQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:02:29 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:48897 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946555AbXBIQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:02:28 -0500
Message-ID: <45CC9B12.7040808@s5r6.in-berlin.de>
Date: Fri, 09 Feb 2007 17:02:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: Coding style question
References: <200702091132.09741.pisa@cmp.felk.cvut.cz>
In-Reply-To: <200702091132.09741.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Pisa wrote:
> There are tightly copled two macros for preparation
> and acquisition of muti-bit masked fields values
> 
> #define __val2mfld(mask,val) (((mask)&~((mask)<<1))*(val)&(mask))
> 
> #define __mfld2val(mask,val) (((val)&(mask))/((mask)&~((mask)<<1)))

The macro names are awkward.
http://lxr.linux.no/source/Documentation/CodingStyle?v=2.6.18#L133

Consider longer names (and to partially counteract column consumption,
omit the leading underscores) or at least spell their purpose out in a
short comment at the macro definitions.
-- 
Stefan Richter
-=====-=-=== --=- -=--=
http://arcgraph.de/sr/
