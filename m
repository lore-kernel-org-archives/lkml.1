Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZHUGwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZHUGwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZHUGwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:52:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46297
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbZHUGwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:52:07 -0400
Date: Thu, 20 Aug 2009 23:52:19 -0700 (PDT)
Message-Id: <20090820.235219.74114618.davem@davemloft.net>
To: elendil@planet.nl
Cc: dfeng@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH,v2] Re: e1000e: why does
 pci_enable_pcie_error_reporting() fail on my hp2510p?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908210848.39377.elendil@planet.nl>
References: <200908210829.10471.elendil@planet.nl>
	<4A8E3FC1.50201@redhat.com>
	<200908210848.39377.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Fri, 21 Aug 2009 08:48:38 +0200

> From: Frans Pop <elendil@planet.nl>
> Subject: net: Don't report an error if devices don't support AER
> 
> The only error returned by pci_{en,dis}able_pcie_error_reporting() is
> -EIO which simply means that Advanced Error Reporting is not supported.
> There is no need to report that, so remove the error check from e1001e,
> igb and ixgbe.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

Intel folks, just let me know what you want me to do with this,
if anything.

Thanks.
