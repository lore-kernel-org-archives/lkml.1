Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYLHPJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYLHPJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYLHPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:09:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35353 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYLHPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:09:24 -0500
Date: Mon, 8 Dec 2008 15:09:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Rafael Wysocki <rwysocki@suse.de>,
       "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Stable@kernel.org" <Stable@kernel.org>
Subject: Re: [PATCH] PCIe ASPM causes machine (HP Compaq 6735s) to sometimes freeze hard at boot at PCI initialization time
Message-ID: <20081208150919.GA1155@srcf.ucam.org>
References: <200811281328.55259.trenn@suse.de> <20081205182148.GA28192@srcf.ucam.org> <1228699962.13024.2.camel@sli10-desk.sh.intel.com> <200812081604.09996.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812081604.09996.trenn@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 04:04:09PM +0100, Thomas Renninger wrote:
> -	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
> +	parent_reg = pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);

I don't think that does what you think it does :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
