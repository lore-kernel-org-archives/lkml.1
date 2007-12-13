Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbXLMHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbXLMHxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbXLMHxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:53:37 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:43604 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbXLMHxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:53:37 -0500
Date: Thu, 13 Dec 2007 08:53:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Message-ID: <20071213085332.18d2790d@poseidon.drzeus.cx>
In-Reply-To: <20071213071311.GA2970@party>
References: <20071213071311.GA2970@party>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 16:13:11 +0900
Kyungmin Park <kyungmin.park@samsung.com> wrote:

> It already checked the ext_csd_struct is less than 2,
> so it doesn't need to check it.
> Current code only accepts the revision 1.2.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

It wasn't wrong the last time you brought this up, and it still isn't wrong. Those bits aren't defined until version 1.2 of the EXT_CSD register, hence we do not trust them. If you have some broken card that you feel you must have support for, then start working on some quirks system.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
