Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXFKT7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXFKT7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXFKT7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:59:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47866 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbXFKT72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:59:28 -0400
Message-ID: <466DA99C.4050105@garzik.org>
Date: Mon, 11 Jun 2007 15:59:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com, arjan@linux.intel.com
Subject: Re: [patch 1/3] Store interrupt value
References: <20070611184146.448266229@intel.com> <20070611114810.f918bc1d.kristen.c.accardi@intel.com>
In-Reply-To: <20070611114810.f918bc1d.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Seems OK, though a bit disappointing that this cannot be initial set in
ahci_save_initial_config() [which admittedly only saves per-HBA settings 
at the moment, but due to new init model, need not be limited as such]

