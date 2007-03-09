Return-Path: <linux-kernel-owner+w=401wt.eu-S1767225AbXCIMu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767225AbXCIMu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767231AbXCIMu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:50:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55690 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767230AbXCIMu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:50:58 -0500
Message-ID: <45F1582D.2050005@garzik.org>
Date: Fri, 09 Mar 2007 07:50:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       s0348365@sms.ed.ac.uk
Subject: Re: [PATCH] sata_nv: revert use of notifiers for now
References: <45F0A40A.4050508@shaw.ca>
In-Reply-To: <45F0A40A.4050508@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a added support for using the
> ADMA notifier bits to determine which commands to check for completion.
> However there have been reports that this causes command timeouts in 
> certain
> cases. This is still being investigated. In addition, apparently the 
> notifiers
> won't work if ADMA is disabled on the other port as a result of an ATAPI 
> device
> being connected, and we don't handle this case properly.
> 
> For now, just restore the previous behavior of checking all active commands
> to see if they are complete, without relying on the notifiers.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied to #upstream-fixes


