Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYKLVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYKLVQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYKLVPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:15:49 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:52230 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984AbYKLVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:15:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=KwdsJs1kNTFw8yp391KT4jAUyCEKHegsylbvTFCGww0+dbFkOgMEGywLw4JtAPeiCkYa5/r/ovbzhY2Lbm2mr4Pu3dtHtCrAXZ3roIAeaRxOemV4l2zBTrpIbsCGR/vq;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 7/7] PCI, ACPI: remove obsolete _OSC capability support functions
Date: Wed, 12 Nov 2008 13:15:31 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, bjorn.helgaas@hp.com
References: <20081110223035.30539.88942.stgit@bob.kio> <20081110223110.30539.19970.stgit@bob.kio>
In-Reply-To: <20081110223110.30539.19970.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121315.32275.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 10, 2008 2:31 pm Andrew Patterson wrote:
> PCI, ACPI: remove obsolete _OSC capability support functions
>
> The acpi_query_osc, __pci_osc_support_set, pci_osc_support_set, and
> pcie_osc_support_set functions have been obsoleted in favor of setting
> these capabilities during root bridge discovery with pci_acpi_osc_support.
> There are no longer any callers of these functions, so they are removed.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>

Ok, applied the rest too.  I'll do a quick test before pushing out the updated 
linux-next branch.

Thanks,
Jesse
