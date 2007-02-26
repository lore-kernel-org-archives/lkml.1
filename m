Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXBZU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXBZU5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161035AbXBZU5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:57:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60414 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029AbXBZU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:57:18 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Milton Miller <miltonm@bga.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       torvalds@linux-foundation.org
In-Reply-To: <35684e789e5c2447eab393c8946efcb9@bga.com>
References: <1172462466.3971.46.camel@shinybook.infradead.org>
	 <35684e789e5c2447eab393c8946efcb9@bga.com>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 15:57:48 -0500
Message-Id: <1172523468.3560.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 10:44 -0600, Milton Miller wrote:
> Any chance you are using one of the unusal code paths, like the 
> bootloader moving the initrd or using a kernel crash region?

I'm doing nothing special. And I'm less sure now about the trigger. I
built a Fedora 7 test 2 install tree with the patch reverted, and
managed to boot and install.... but now when I boot the _same_ machine
with the same CD, it fails. 

Now I'm starting to wonder if it's something the firmware sets up to DMA
to a certain region of memory, which makes it non-deterministic. And the
other things we're blaming are only making a difference because they
change the layout of what we have in memory.

-- 
dwmw2

