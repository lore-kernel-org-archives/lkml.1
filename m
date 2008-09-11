Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYIKUjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYIKUjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYIKUix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:38:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYIKUiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:38:52 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080911201541.GA18518@kroah.com>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com>
	 <1221151165.6309.55.camel@californication>
	 <20080911201541.GA18518@kroah.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 13:38:38 -0700
Message-Id: <1221165518.4077.17.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 13:15 -0700, Greg KH wrote:
> This is the firmware that is in the kernel source tree, that has been
> moved to use request_firmware, and was originally tied tightly to the
> kernel drivers themselves.

Not really. Most of it hasn't changed for years; it isn't _really_ tied
that closely to the kernel. 

You can just ignore what the kernel ships with, and install the firmware
from the linux-firmware.git repository instead.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

