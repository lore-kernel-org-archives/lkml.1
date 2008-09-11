Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYIKPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYIKPbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYIKPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:31:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYIKPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:31:14 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200809111725.01511.elendil@planet.nl>
References: <48C68507.6000609@suse.com>
	 <200809111152.58187.elendil@planet.nl>
	 <1221144627.8593.9.camel@macbook.infradead.org>
	 <200809111725.01511.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 08:31:08 -0700
Message-Id: <1221147068.8593.31.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 17:24 +0200, Frans Pop wrote:
> Did you read the second part of the mail explaining why having a 
> single "firmware" package is not a good idea?

Yes, but it was nonsense, so I ignored it. "The reason for this is the
possibility that a driver and its firmware may be dropped from the
upstream kernel source." That doesn't happen very often, and you
_certainly_ don't need to immediately drop the firmware if it does.

It's another reason why it's better to be shipping from the external
linux-firmware repository at
git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
-- because if a driver _does_ go away, that repository would continue to
carry the firmware files. But since that's such an infrequent
occurrence, there's no massive rush. Using the firmware in the kernel
tree is fine for now.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

