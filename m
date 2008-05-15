Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYEOBQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYEOBQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYEOBQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:16:04 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41875 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYEOBQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:16:03 -0400
Date: Thu, 15 May 2008 10:12:25 +0900
To: randy.dunlap@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 1/2] add the device argument to dma_mapping_error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080513083901.2f571418.randy.dunlap@oracle.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080513083901.2f571418.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080515101207T.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 08:39:01 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 13 May 2008 15:04:51 +0900 FUJITA Tomonori wrote:
> 
> > dma_mapping_error doesn't take a pointer to the device unlike other
> > DMA operations. So we can't have dma_mapping_ops per device.
> > 
> > Note that POWER already has dma_mapping_ops per device but all the
> > POWER IOMMUs use the same dma_mapping_error function. x86 IOMMUs use
> > different dma_mapping_error functions. So dma_mapping_error needs the
> > device argument.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

(snip)

> Seems to be missing updates to Documentation/DMA-API.txt ??

Oops, I'll post an updated version against -mm soon.

Thanks,
