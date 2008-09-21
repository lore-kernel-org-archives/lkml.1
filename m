Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYIUWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYIUWp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYIUWpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:45:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41357 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYIUWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:45:12 -0400
Date: Sun, 21 Sep 2008 23:45:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921224506.GB24461@srcf.ucam.org>
References: <20080921172316.GA6306@2ka.mipt.ru> <1222025731.6782.117.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222025731.6782.117.camel@californication>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 09:35:31PM +0200, Marcel Holtmann wrote:

> I don't know if it is for this bug or a different one, but Matthew
> Garrett seem to have some pending patches. At least that is what he told
> me at PlumbersConf. Lets see if these patches do help. And please follow
> up with Arjan's suggestion and put a WARN_ON in the upstream code
> instead of waving CONFIG_BROKEN around.

The fix I had for this was actually for ipw2200, but it ought to be 
applicable for 2100 as well. The ideal fix is probably to ensure that 
ipw*_down D3s the card and *_up D0s it, which brings enhanced runtime 
power saving and also has the nice side effect of actually resetting the 
damned POS in error cases.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
