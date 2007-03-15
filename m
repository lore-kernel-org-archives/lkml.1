Return-Path: <linux-kernel-owner+w=401wt.eu-S1030369AbXCOPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbXCOPA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030396AbXCOPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:00:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50151 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369AbXCOPA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:00:27 -0400
Message-ID: <45F95F84.8030308@garzik.org>
Date: Thu, 15 Mar 2007 11:00:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: broonie@sirena.org.uk
CC: Tim Hockin <thockin@hockin.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] natsemi: Consistently use interrupt enable/disable
 functions
References: <20070314194912.414925000@sirena.org.uk> <20070314195156.690711000@sirena.org.uk>
In-Reply-To: <20070314195156.690711000@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

broonie@sirena.org.uk wrote:
> The natsemi drivers include functions for enabling and disabling
> interrupts from the chip but these are not used in all code paths.  This
> patch changes the code paths that touch the interrupt enable register to
> use the functions.  In all cases this adds an extra PCI read to post the
> operation but since none of these are in fast paths this shouldn't be
> too much of a problem.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>

applied 1-3 to #upstream-fixes


