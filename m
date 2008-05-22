Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbYEVVUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbYEVVUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934565AbYEVVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:19:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61215 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764454AbYEVVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nliy4fWyCx8pjGNU2b4PJtUUDF7gG2B9qBFee/2+jPZHwsh8QzSLM7ylPNCDYmtQXo8jmNKsJim+xhfXUW/z8eJxK86EGZCuLQe81Ysm8IJjjb9ENSMfegj87tHBupIJp4yB1hTI1UZhQBSClcp6onxMuss7r9eZ8iwwnWvcdoI=
Date: Fri, 23 May 2008 01:19:42 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [RFC][PATCH 0/2] Clocklib: generic clocks framework
Message-ID: <20080522211942.GA11271@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the followup mails I'd like to introduce a bit new approach for
"clocklib".
First, it's based on kobjects. So we do get sysfs integration nearly for
free. Also now struct clk is completely opaque. So we can change it's
implementation without impacting clocks providers.

Also in clk_ops I've merged (as suggested by Haavard) the set_rate and
round_rate calls since they usually have lots of common code.

The clk_set_parent() isn't implemented yet, but this code is only an RFC!

-- 
With best wishes
Dmitry

