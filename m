Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYDTI2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYDTI2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYDTI2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:28:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48191 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYDTI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=sDjgbzF8xoMcdiXj5iEHr/+kA+MZJJ+UvcuLvwta1f9p0LVoDnGEr1eJpJDyL8mdENpVwDs/HCjcMGZmBn0+AgsNQ5mHh2xAY4RiMdVjgNf5aO9tp0hVqriL/TryDi5xZ+fmk8AotG+6a/+bqr26hiB3xxdy/NESPedJZLFK/7A=
Date: Sun, 20 Apr 2008 12:28:20 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080420082820.GA32683@doriath.ww600.siemens.net>
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

