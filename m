Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZKZDA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZKZDA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZKZDA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:00:57 -0500
Received: from ozlabs.org ([203.10.76.45]:33248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbZKZDAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:00:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19213.61189.559138.936155@drongo.ozlabs.ibm.com>
Date: Thu, 26 Nov 2009 13:59:17 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/3] Kernel DLPAR Infrastructure
In-Reply-To: <4B0CD879.9020400@austin.ibm.com>
References: <4B0CD70F.6090600@austin.ibm.com>
	<4B0CD879.9020400@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> The Dynamic Logical Partitioning capabilities of the powerpc pseries platform
> allows for the addition and removal of resources (i.e. CPU's, memory, and PCI
> devices) from a partition. The removal of a resource involves
> removing the resource's node from the device tree and then returning the
> resource to firmware via the rtas set-indicator call.  To add a resource, it
> is first obtained from firmware via the rtas set-indicator call and then a
> new device tree node is created using the ibm,configure-coinnector rtas call
> and added to the device tree. 
> 
> This patch provides the kernel DLPAR infrastructure in a new filed named
> dlpar.c.  The functionality provided is for acquiring and releasing a resource
> from firmware and the parsing of information returned from the
> ibm,configure-connector rtas call.  Additionally this exports the pSeries
> reconfiguration notifier chain so that it can be invoked when device tree 
> updates are made.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com> 

Acked-by: Paul Mackerras <paulus@samba.org>
