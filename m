Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZKDRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZKDRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZKDRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:25:55 -0500
Received: from outbound-mail-135.bluehost.com ([67.222.39.25]:52489 "HELO
	outbound-mail-135.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751667AbZKDRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:25:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VeAudHd2fjSaZHJwoCuLC4F0Z3HuAyau1JKF5iTjpzvha6w5SFVDO4t50AOU8xOlqs50r7PT6iss/jrgM59Ifb7nGe6Wr+6f5fjEITJSRk9Qzy5PfntGn+jJz2k+lU2Q;
Date: Wed, 4 Nov 2009 09:25:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: ying.huang@intel.com, prarit@redhat.com, linux-pci@vger.kernel.org,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] PCI: add pci_get_domain_bus_and_slot function
Message-ID: <20091104092556.3a726e9d@jbarnes-piketon>
In-Reply-To: <20091012191359.14959.65418.stgit@bob.kio>
References: <20091012191354.14959.47024.stgit@bob.kio>
	<20091012191359.14959.65418.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 13:14:00 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> PCI: add pci_get_domain_bus_and_slot function
> 
> Added the pci_get_domain_and_slot_function which is analogous to
> pci_get_bus_and_slot. It returns a pci_dev given a domain (segment)
> number, bus number, and devnr. Like pci_get_bus_and_slot,
> pci_get_domain_bus_and_slot holds a reference to the returned pci_dev.
> 
> Converted pci_get_bus_and_slot to a wrapper that calls
> pci_get_domain_bus_and_slot with the domain hard-coded to 0.
> 
> This routine was patterned off code suggested by Bjorn Helgaas.

Applied this series, thanks Andrew.

-- 
Jesse Barnes, Intel Open Source Technology Center
