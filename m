Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZA0BWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZA0BWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZA0BWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:22:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbZA0BWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:22:07 -0500
Date: Mon, 26 Jan 2009 17:22:02 -0800 (PST)
Message-Id: <20090126.172202.261408793.davem@davemloft.net>
To: patrick.ohly@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: hardware time stamping with optional structs in data area
From: David Miller <davem@davemloft.net>
In-Reply-To: <1233002392.23161.6.camel@pohly-MOBL>
References: <1232532457.7829.19.camel@ecld0pohly>
	<20090125.210442.129666692.davem@davemloft.net>
	<1233002392.23161.6.camel@pohly-MOBL>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Ohly <patrick.ohly@intel.com>
Date: Mon, 26 Jan 2009 21:39:52 +0100

> On Mon, 2009-01-26 at 07:04 +0200, David Miller wrote:
> > Just consolidate the array into a direct conversion table.  You only
> > have 2 bits defined so you only need an array of 4 entries.  Pass the
> > optional flag bits directly in as the index of that table.
> 
> How can I get some code executed during the initialization of the IP
> stack which initializes the table, before any sk_buff gets allocated?
> 
> The content is constant, but writing it down as static initializers
> using just preprocessor macros would be difficult and/or ugly - that's
> why I haven't done it already.

It's 4 entries... really.  You can initialize them simply, perhaps
with some fancy macro used by the initializers.
