Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYDTI3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYDTI3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYDTI3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:29:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49701 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYDTI3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=mTkCW4ZJG/2rY4cL0PykKA/SLA0/mnK0vlPEns3y7uuxZfV0qR4muJ9Z07KTPf5C729cV+Z3Q5YsHkI+BJSfsT2eC8HIrzU89HGEsi4a0M9pZ1jdQQCMVCUQICYv3kNsHKqGhf8jzp98whK6PA56JAjewvypqeEbJ07IPtvYEyk=
Date: Sun, 20 Apr 2008 12:29:25 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080420082925.GA32739@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my latest version of the patchset.
I'd like to ask for it's inclusion into mainline.
Russell, since currently it's only ARM-only thing, I'd like to ask you
for your opinion on this.


Issues addressed in this version:

 * Simplify clk_function declarations but not messing with a lot of
   pointers.
 * Drop FUNC_TO_CLK as it's totally unused now.
 * Drop spurious kfree from the clk_alloc_function error path.

-- 
With best wishes
Dmitry

