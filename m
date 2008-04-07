Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYDGQHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYDGQHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYDGQHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:07:32 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:52123 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754204AbYDGQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:07:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch v2] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
Date: Mon, 7 Apr 2008 09:05:51 -0700
User-Agent: KMail/1.9.9
Cc: Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       Grant Grundler <grundler@parisc-linux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <935779.51834.qm@web52004.mail.re2.yahoo.com>
In-Reply-To: <935779.51834.qm@web52004.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804070905.51499.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2008 9:01 am Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
>
> Fix undeclared variables in code examples.
> Consistently use pdev as the variable of type struct pci_dev *.
> Bug 10397.

I think Grant's comment still stands, "fix undeclared variables" isn't an 
accurate description of what you're doing here...

That said, the patch itself looks fine to me, if a bit pedantic.  The compiler 
will catch any mismatched arguments in this case, and the rest of the 
documentation is pretty clear that these routines take struct pci_dev not 
struct device, so I'd be inclined to just leave it the way it is to avoid 
churn.

Jesse
