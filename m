Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZLAAKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZLAAKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZLAAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:10:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:39146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZLAAKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:10:08 -0500
Message-ID: <4B145EAF.8030909@kernel.org>
Date: Mon, 30 Nov 2009 16:09:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32	registers
References: <20091130212228.7555.43533.stgit@debian.lart> <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home> <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home> <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home> <4B1455FD.90002@kernel.org> <20091201000049.GC24539@lackof.org>
In-Reply-To: <20091201000049.GC24539@lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Mon, Nov 30, 2009 at 03:32:13PM -0800, Yinghai Lu wrote:
>> IORESOURCE_MEM_64 get set when PCI_PREF_RANGE_TYPE_64 is set.
> 
> PCI_PREF_RANGE_TYPE_64 is when we read BARs. It doesn't indicate
> anything about PCI Bridge Window registers AFAIK.
> 

please double check pci-to-pci bridge 1.2, in page 47.

YH


