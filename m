Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYJAQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYJAQdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJAQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:33:27 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:38079 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752571AbYJAQd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:33:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tFheCkhxe46u755l2YB9QpRlwJdJmrneT0GjoZXtgSRQtZBL7OMpMuA2XD+qo0b+IfxRtmRWoYLhdBtn3uQV+mkcq896KtKezxD1a/OcpCa3XNGx6BTwgyUSys52gBSN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] merge the define of PCI_CFG_SPACE_SIZE
Date: Wed, 1 Oct 2008 09:33:23 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
References: <1222484933.25574.35.camel@ymzhang>
In-Reply-To: <1222484933.25574.35.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810010933.23563.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 26, 2008 8:08 pm Zhang, Yanmin wrote:
> Subject: pci: merge define of PCI_CFG_SPACE_SIZE
> ﻿From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
>
> 3 files define PCI_CFG_SPACE_SIZE. Move the define to file
> pci_regs.h.
>
> ﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Applied to linux-next, thanks for a nice cleanup.

Now we just need to pull some of the other silliness out of the PCIe feature 
drivers (for instance making a generic pcie_find_capability).

Jesse
