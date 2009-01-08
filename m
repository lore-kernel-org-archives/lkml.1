Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbZAHTIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbZAHTIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbZAHTIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:08:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49400
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758006AbZAHTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:08:33 -0500
Date: Thu, 08 Jan 2009 11:08:35 -0800 (PST)
Message-Id: <20090108.110835.109199764.davem@davemloft.net>
To: inaky@linux.intel.com
Cc: netdev@vger.kernel.org, wimax@linuxwimax.org, greg@kroah.com,
       randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wimax@intel.com
Subject: Re: [PATCH 4/4] i2400m/usb: wrap USB power saving in #ifdef
 CONFIG_PM
From: David Miller <davem@davemloft.net>
In-Reply-To: <0e511f3772ac9887551bec34ee682fa5bf63fb69.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
	<0e511f3772ac9887551bec34ee682fa5bf63fb69.1231355768.git.inaky@linux.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Wed,  7 Jan 2009 11:22:22 -0800

> Current code was assuming PM was always enabled, which is not
> correct. Code which accesses members in the struct usb_device that are
> dependant on CONFIG_PM must be protected the same.
> 
> Reported by Randy Dunlap from a build error in the linux-next tree on
> 07/01/2009.
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Also applied, thanks a lot.
