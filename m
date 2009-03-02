Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZCBQ5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZCBQ5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZCBQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:56:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:34863 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZCBQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:56:51 -0500
Message-ID: <49AC0FAB.6000604@oracle.com>
Date: Mon, 02 Mar 2009 08:56:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: linux-next: Tree for March 2 (wireless/b43)
References: <20090302182217.90ca3356.sfr@canb.auug.org.au>
In-Reply-To: <20090302182217.90ca3356.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49AC0FBE.028A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090227:
> 
> Undropped trees:
> 	wireless

when CONFIG_SSB_DRIVER_PCICORE=n:

        if ((bus->bustype == SSB_BUSTYPE_PCI) &&
            (bus->pcicore.dev->id.revision <= 10))
                hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */

==>
drivers/net/wireless/b43/main.c:4182: error: 'struct ssb_pcicore' has no member named 'dev'


