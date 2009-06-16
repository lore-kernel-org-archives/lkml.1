Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZFPHAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZFPHAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZFPHAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:00:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:44268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZFPHAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:00:02 -0400
Subject: Re: linux-next: Linus/powerpc tree build warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Linn <john.linn@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Suneel <suneelg@xilinx.com>, linuxppc-dev@ozlabs.org
In-Reply-To: <20090616162429.07e74e75.sfr@canb.auug.org.au>
References: <20090616162429.07e74e75.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 16:59:46 +1000
Message-Id: <1245135586.12400.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 16:24 +1000, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next build (powerpc ppc44x_defconfig) produced this warning:
> 
> drivers/video/xilinxfb.c: In function 'xilinxfb_assign':
> drivers/video/xilinxfb.c:328: warning: cast to pointer from integer of different size
> 
> Introduced by commit dac4ccfb64bcdd5b4c248ccc22903d67486573cd ("fbdev:
> Add PLB support and cleanup DCR in xilinxfb driver").

Known problem, a fix is currently being polished by Grant and John.

Cheers,
Ben.


