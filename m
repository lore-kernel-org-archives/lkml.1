Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbXGRN2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbXGRN2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbXGRN2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:28:17 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:31654 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbXGRN2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:28:14 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] lro: Generic Large Receive Offload for TCP traffic (IPv6)
Date: Wed, 18 Jul 2007 15:00:59 +0200
User-Agent: KMail/1.8.2
Cc: hch@infradead.org, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com
References: <200707111621.24852.ossthema@de.ibm.com> <20070715091253.GA15790@infradead.org> <20070715.024015.126137834.davem@davemloft.net>
In-Reply-To: <20070715.024015.126137834.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181501.00163.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I suggest we keep the interface open for IPv6 support by adding 
an additional parameter but first just get IPv4 support only 
into the kernel. IPv6 support can then incrementially be added.
Would that be ok?



On Sunday 15 July 2007 11:40, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Sun, 15 Jul 2007 10:12:53 +0100
> 
> > I'm not sure that's a good idea.  If current chips can't handle ipv6
> > lro there is no way to actually test it and the code will surely bitrot.
> 
> Christoph, you can do LRO pretty much completely in software.
> 
> 
