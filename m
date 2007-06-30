Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXF3MGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXF3MGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXF3MGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 08:06:07 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:59294 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbXF3MGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 08:06:06 -0400
Date: Sat, 30 Jun 2007 13:05:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>
Cc: zambrano@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, power@bughost.org
Message-ID: <20070630120541.GA21339@srcf.ucam.org>
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] b44: power down PHY when interface down
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 02:47:35PM +0300, Török Edvin wrote:
> When the interface is down (or driver removed), the BroadCom 44xx card 
> remains
> powered on, and both its MAC and PHY is using up power.
> This patch makes the driver issue a MAC_CTRL_PHY_PDOWN when the interface
> is halted, and does a partial chip reset turns off the activity LEDs too.

Do you still get link beat detection when the phy is powered down?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
