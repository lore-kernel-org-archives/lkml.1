Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYFAOp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYFAOp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYFAOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38607 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFAOo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:44:59 -0400
Date: Sun, 1 Jun 2008 15:44:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 5/7] mmc: at91_mci: update bytes_xfered value once xfer done
Message-ID: <20080601144439.GT5818@flint.arm.linux.org.uk>
References: <483FE9E7.7020707@atmel.com> <483FF0B1.6010500@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483FF0B1.6010500@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 02:18:57PM +0200, Nicolas Ferre wrote:
> Modify bytes_xfered value after a write.
> 
> That will report, as accurately as possible, the amount of 
> sectors that are effectively written.
> 
> This update introduces the check of the busy signal given by
> the card.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Doesn't this patch depend on patch 4?  IOW, shouldn't you be correcting
this before you enable the features which require this to be accurate?
