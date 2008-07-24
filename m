Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYGXPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYGXPJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYGXPI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:08:57 -0400
Received: from bay0-omc3-s2.bay0.hotmail.com ([65.54.246.202]:17127 "EHLO
	bay0-omc3-s2.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757852AbYGXPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:08:57 -0400
Message-ID: <BAY103-DAV74E605DFBE7CC22EEA732B2870@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <BAY103-DAV1DBA31C9BCB4C6FFB3DE0B2870@phx.gbl> <20080723.234556.98132946.davem@davemloft.net>
Subject: Re: 2.6.26: [<c0133cc1>] __alloc_pages_internal+0x331/0x343
Date: Thu, 24 Jul 2008 17:06:30 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 24 Jul 2008 15:07:47.0456 (UTC) FILETIME=[0847B800:01C8ED9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> > Jul 23 12:40:03 Electra kernel:  [<c024d2a5>]
> > pskb_expand_head+0x41/0x164
> > Jul 23 12:40:03 Electra kernel:  [<c029a6b4>]
> > ipcomp_decompress+0x60/0xa1
>
> ipcomp_decompress() should probably be changed to try and build
> a scatterlist of pages for the resulting packet SKB data instead
> of building a linear buffer as it does now.

Thanks for the reply.
I got a similar error today also with 2.6.25.10
after 20 days uptime.
This box is running 2.6.25 since april 22: I have
never seen these errors.


