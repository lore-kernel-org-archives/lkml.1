Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXDMHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXDMHhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXDMHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:37:20 -0400
Received: from verein.lst.de ([213.95.11.210]:36786 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXDMHhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:37:19 -0400
Date: Fri, 13 Apr 2007 09:37:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: gerg@snapgear.com
Cc: linux-kernel@vger.kernel.org
Subject: 68328serial & pm_register
Message-ID: <20070413073720.GA14437@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

68328serial is the last driver to call pm_register and thus using and
keeping alive the really old PM scheme.  Any chance to convert it over
to platform devices (which would also clean up a lot of the ifdef
mess in the driver), or simply rip out that rudimentary PM support?

On a less urgent basis, is there any chance to convert the driver
to use serial_core, which it doesn't despite living in drivers/serial?
