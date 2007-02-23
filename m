Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXBWKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXBWKh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbXBWKh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:37:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44894 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbXBWKh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:37:27 -0500
Message-ID: <45DEC3E5.6030004@garzik.org>
Date: Fri, 23 Feb 2007 05:37:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sata_nv: kill old private BMDMA helper functions
References: <45DBC136.9060103@shaw.ca>
In-Reply-To: <45DBC136.9060103@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> sata_nv implemented its own copies of the BMDMA helper functions for ADMA,
> since the ADMA BMDMA status registers are PIO while the other registers
> are MMIO, and this was the only way to handle this previously. Now that
> we have iomap support, the standard routines should just work, so use them.
> The only thing we need to override as far as ADMA and BMDMA is the
> post_internal_cmd callback, where we should only call ata_post_internal_cmd
> if we are in port-register mode.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied


