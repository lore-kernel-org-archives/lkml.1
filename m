Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXKASN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXKASN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXKASNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:13:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbXKASNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:13:46 -0400
Date: Thu, 1 Nov 2007 11:11:56 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       davej@redhat.com, auke-jan.h.kok@intel.com, ajax@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000, e1000e valid-addr fixes
Message-ID: <20071101111157.7f3e4f58@freepuppy.rosehill>
In-Reply-To: <471EABEE.8030900@garzik.org>
References: <20071023.145339.55504234.davem@davemloft.net>
	<471E9801.2000006@garzik.org>
	<471E99E8.6030404@garzik.org>
	<20071023.180744.115914004.davem@davemloft.net>
	<471EABEE.8030900@garzik.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about:

static int eth_validate_addr(const struct net_device *dev)
{
	return is_valid_ether_addr(dev->dev_addr) ? 0 : -EINVAL;
}

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
