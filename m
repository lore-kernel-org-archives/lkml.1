Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbXIXTWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbXIXTWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXIXTWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:22:36 -0400
Received: from smtp100.biz.mail.mud.yahoo.com ([68.142.201.176]:42615 "HELO
	smtp100.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755111AbXIXTWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:22:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 15:22:35 EDT
X-YMail-OSG: QRlXbCMVM1nCT4IZHAMpNGA8BByIc.3FmHBYzcled0nArWs8wRvdD9_hhat7aC4w88TBdiUZJ6CpniO4tuY0YB9.SS5x
In-Reply-To: <46F80049.2030509@freescale.com>
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com> <46F7EE95.1040509@scram.de> <46F80049.2030509@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <FF1A2486-BE77-49F8-99F3-B09B4EEAF50D@embeddedalley.com>
Cc: Jochen Friedrich <jochen@scram.de>, linux-kernel@vger.kernel.org,
       linuxppc-embedded@ozlabs.org
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
Date: Mon, 24 Sep 2007 12:16:05 -0700
To: Scott Wood <scottwood@freescale.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2007, at 11:22 AM, Scott Wood wrote:

> cpmp is a physical address on arch/ppc?

No, it's a well known ioremaped() address
into the IMMR space.  The only physical
addresses in any of the CPM/CPM2 are
those required to by the buffer descriptors.
There are DPRAM offsets, but they should
be just that, offsets from either a virtual
or physical base address as required.
Too many people screw around in this
CPM support code without fully understanding
the original implementation or its intended
use with the peripheral drivers.  A "better
idea" often breaks all drivers except the one
that is being changed.

	-- Dan

