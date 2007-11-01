Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXKAFJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXKAFJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXKAFJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:09:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38384 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753260AbXKAFJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:09:07 -0400
Date: Thu, 1 Nov 2007 06:08:55 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: RFC: remove CONFIG_EXPERIMENTAL
Message-ID: <20071101050855.GY7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm about to send a patch that removes the EXPERIMENTAL option and all 
dependencies on EXPERIMENTAL because they are pointless.

Complete rationale:
- Many people and all distributions are currently forced to enable 
  CONFIG_EXPERIMENTAL since the options for many device drivers depend 
  on this option.
  I have yet to see someone not being able to install his favorite 
  distribution on his computer only because the distribution did choose 
  to disable all SATA drivers with dependencies on EXPERIMENTAL in their
  kernels...
- History has shown that often the dependency on EXPERIMENTAL is not 
  removed when the code has proven usable.
  As an example, is our NFSv4 support really still in an
  "alpha-test phase" [1], or is it already ready for being used?
  I don't know the answer in this specific case, but I wouldn't answer
  "still in an alpha-test phase" only based on the fact that the NFSv4 
  options still depend on EXPERIMENTAL.
- It might have been differently 10 years ago, but today everything that
  is available in a released kernel should also be in a usable state.

cu
Adrian

[1] quoted from the CONFIG_EXPERIMENTAL help text

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

