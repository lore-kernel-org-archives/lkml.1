Return-Path: <linux-kernel-owner+w=401wt.eu-S1030189AbXBTQTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189AbXBTQTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030199AbXBTQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:19:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44512 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030195AbXBTQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:19:00 -0500
Message-ID: <45DB1F70.608@garzik.org>
Date: Tue, 20 Feb 2007 11:18:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Tim Hockin <thockin@hockin.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/2] natsemi: Add support for using MII port with no PHY
References: <20070219201538.420238000@sirena.org.uk> <20070219201858.688614000@sirena.org.uk>
In-Reply-To: <20070219201858.688614000@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> This patch provides code paths which allow the natsemi driver to use the
> external MII port on the chip but ignore any PHYs that may be attached to it.
> The link state will be left as it was when the driver started and can be
> configured via ethtool.  Any PHYs that are present can be accessed via the MII
> ioctl()s.
> 
> This is useful for systems where the device is connected without a PHY
> or where either information or actions outside the scope of the driver
> are required in order to use the PHYs.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
> 
> ---
> 
> This revision of the patch fixes some issues brought up during review.
> 
> Previous versions of this patch exposed the new functionality as a module
> option.  This has been removed.  Any hardware that needs this should be
> identifiable by a quirk since it unlikely to behave correctly with an
> unmodified driver.

applied 1-2


