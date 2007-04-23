Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXDWOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXDWOVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXDWOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:21:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbXDWOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:21:23 -0400
Date: Mon, 23 Apr 2007 10:21:14 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Nvidia AGP: Use refcount aware PCI interfaces
Message-ID: <20070423142114.GA19674@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20070423145027.47f1ba38@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423145027.47f1ba38@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 02:50:27PM +0100, Alan Cox wrote:
 > Signed-off-by: Alan Cox <alan@redhat.com>

This is lacking a changelog.  What's the purpose of changing this?
Is pci_find_slot() obsolete and going away? (If so, it should be
marked as such).  These devices aren't hotpluggable, so I'm not
sure why they need to be reference counted.

Inquisitive minds would like to know more.

	Dave

-- 
http://www.codemonkey.org.uk
