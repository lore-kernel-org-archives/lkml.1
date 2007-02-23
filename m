Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbXBWKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbXBWKh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbXBWKh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:37:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44931 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbXBWKh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:37:56 -0500
Message-ID: <45DEC402.4030205@garzik.org>
Date: Fri, 23 Feb 2007 05:37:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: complain on spurious completion notifiers
References: <45DD2FBF.1040808@shaw.ca>
In-Reply-To: <45DD2FBF.1040808@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Recently Tejun wrote a patch to ahci.c to make it raise a HSM violation
> if the drive attempted to complete a tag that wasn't outstanding. We could
> run into the same problem with sata_nv ADMA. This adds code to raise a HSM
> violation error if the controller gives us a notifier tag that isn't
> outstanding, since the drive may be issuing spurious completions.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied


