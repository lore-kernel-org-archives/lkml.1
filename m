Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbZAaDPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbZAaDPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbZAaC5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:57:50 -0500
Received: from rtr.ca ([76.10.145.34]:56096 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760286AbZAaC5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:57:49 -0500
Message-ID: <4983BE2B.90805@rtr.ca>
Date: Fri, 30 Jan 2009 21:57:47 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: stable@kernel.org
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: For -stable: sata_mv: fix 8-port timeouts on 508x/6081 chips
References: <20090131023906.GA12147@kroah.com>
In-Reply-To: <20090131023906.GA12147@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b0bccb18bc523d1d5060d25958f12438062829a9
Author: Mark Lord <liml@rtr.ca>
Date:   Mon Jan 19 18:04:37 2009 -0500

    sata_mv: fix 8-port timeouts on 508x/6081 chips
    
    Fix a longstanding bug for the 8-port Marvell Sata controllers (508x/6081),
    where accesses to the upper 4 ports would cause lost-interrupts / timeouts
    for the lower 4-ports.  With this patch, the 6081 boards should finally be
    reliable enough for mainstream use with Linux.
    
    Signed-off-by: Mark Lord <mlord@pobox.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>


This should be backported to all -stable kernels.

Cheers
