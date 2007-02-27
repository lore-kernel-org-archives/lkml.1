Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXB0Jbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXB0Jbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161102AbXB0Jbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:31:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47587 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161098AbXB0Jbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:31:42 -0500
Message-ID: <45E3FA5B.8040306@garzik.org>
Date: Tue, 27 Feb 2007 04:31:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
       Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@stusta.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: natsemi: Fix detection of vanilla natsemi cards
References: <20070225153726.GB15068@sirena.org.uk>
In-Reply-To: <20070225153726.GB15068@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Bob Tracy <rct@gherkin.frus.com> reported that the addition of support
> for Aculab E1/T1 cPCI carrier cards broke detection of vanilla natsemi
> cards.  This patch fixes that: the problem is that the driver-specific
> ta in the PCI device table is an index into a second table and this
> had not been updated for the vanilla cards.
> 
> This patch fixes the problem minimally.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>

applied


