Return-Path: <linux-kernel-owner+w=401wt.eu-S2992663AbXDDFuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992663AbXDDFuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992664AbXDDFuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:50:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58761
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992663AbXDDFuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:50:08 -0400
Date: Tue, 03 Apr 2007 22:50:06 -0700 (PDT)
Message-Id: <20070403.225006.119275067.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175663999.2932.8.camel@shinybook.infradead.org>
References: <20070404022544.59b022a6@the-village.bc.nu>
	<17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	<1175663999.2932.8.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 04 Apr 2007 01:19:59 -0400

> I don't see why that 'should' be the case. Certainly it _isn't_ the case
> on most supported platforms -- we have separate device numbers, and
> names, for most types of ports. There's only one or two drivers which
> abuse ttySn for anything other than 8250 ports.

sunsu, sunzilog, pmac_zilog, sunsab, etc.

The list is longer than you think.  In fact the convention is
very well established.
