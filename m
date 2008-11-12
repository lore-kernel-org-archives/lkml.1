Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYKLU6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYKLU6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKLU6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:58:40 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:42511 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752303AbYKLU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:58:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Ynig9MkqAxB4E2z8b5F6xGAzqk5RfUvKFhDXn2sWe/Bc/ApwA16+ZMGH4VvP4NJ3681tKH1wkJ9qN5w5O1SbAEourThPII0rTqNf8D+TED9PrBoSC/FBJQknv1dpgde3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 2/7] ACPI, PCI: call _OSC support during root bridge discovery
Date: Wed, 12 Nov 2008 12:58:25 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, bjorn.helgaas@hp.com
References: <20081110223035.30539.88942.stgit@bob.kio> <20081110223045.30539.6794.stgit@bob.kio>
In-Reply-To: <20081110223045.30539.6794.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121258.26696.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 10, 2008 2:30 pm Andrew Patterson wrote:
> ACPI, PCI: call _OSC support during root bridge discovery
>
> Added pci_acpi_osc_support() which is called when a PCI bridge is
> added, so individual PCI root bridge drivers do not have to call _OSC
> support for every root bridge in their probe functions.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Applied these first two, I'll be applying the rest shortly.

Thanks,
Jesse
