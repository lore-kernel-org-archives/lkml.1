Return-Path: <linux-kernel-owner+w=401wt.eu-S936187AbXGMOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187AbXGMOsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761300AbXGMOsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:48:25 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58624 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761270AbXGMOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:48:24 -0400
Date: Fri, 13 Jul 2007 15:48:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Mark Mason <mason@broadcom.com>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-duart.c: SB1250 DUART serial support
Message-ID: <20070713144818.GC8190@linux-mips.org>
References: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl> <20070712114712.de5d6c9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712114712.de5d6c9d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:47:12AM -0700, Andrew Morton wrote:

> There is no power management support in this driver.

There is hardly anything software could do to safe power on Sibyte SOCs.
Just like most other MIPS SOCs power managment is mostly left to the
hardware which does it by using extensive clockgating and other design
techniques.  As a SW person I can't protest that approach :-)

  Ralf
