Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbZAHTH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbZAHTH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZAHTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:07:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49380
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756653AbZAHTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:07:41 -0500
Date: Thu, 08 Jan 2009 11:07:43 -0800 (PST)
Message-Id: <20090108.110743.163052787.davem@davemloft.net>
To: inaky@linux.intel.com
Cc: netdev@vger.kernel.org, wimax@linuxwimax.org, greg@kroah.com,
       randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wimax@intel.com
Subject: Re: [PATCH 2/4] wimax: fix kconfig interactions with rfkill and
 input layers
From: David Miller <davem@davemloft.net>
In-Reply-To: <f0f7dc5763046cc336ca087a2525c8b52811ddb4.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
	<f0f7dc5763046cc336ca087a2525c8b52811ddb4.1231355768.git.inaky@linux.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Wed,  7 Jan 2009 11:22:20 -0800

> WiMAX can work without RFKILL, but it was missing a check to make sure
> RFKILL is not being made a module with wimax compiled into the
> kernel. This caused failed builds in s390, where CONFIG_INPUT is
> always off.
> 
> When RFKILL is enabled, the code uses the input layer to report
> hardware switch changes; thus, if RFKILL is enabled, INPUT has to be
> too. It also needs to display some message when INPUT is disabled that
> explains why WiMAX is not selectable.
> 
> (issues found by Randy Dunlap in the linux-next tree).
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Applied.
