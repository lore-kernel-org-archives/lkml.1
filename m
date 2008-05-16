Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYEPHqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYEPHqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYEPHpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:45:52 -0400
Received: from bay0-omc1-s35.bay0.hotmail.com ([65.54.246.107]:29948 "EHLO
	bay0-omc1-s35.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYEPHpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:45:52 -0400
Message-ID: <BAY103-DAV7AAC1BD4FD2FBCE25B6FBB2C80@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Eric Sandeen" <sandeen@sandeen.net>
Cc: "David Chinner" <dgc@sgi.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>, <nuclearcat@nuclearcat.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com> <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl> <482062F5.9010402@sandeen.net> <482CAE26.8080707@sandeen.net>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Fri, 16 May 2008 09:43:14 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 16 May 2008 07:45:51.0447 (UTC) FILETIME=[DD011670:01C8B728]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> Eric Sandeen wrote:
> > Marco Berizzi wrote:
> >> David Chinner wrote:
> >>
> >>> Hmmmmm - interesting. Both the reports of this problem are from
> >>> machines running as squid proxies. Are you using AUFS for the
cache?
> >> no, I'm using cache_dir ufs with cache_replacement_policy heap
LFUDA
>
> Christoph recently sent a patch to the xfs list which resolves my
> testcase for this problem, FYI.
>
> [PATCH] fix memory corruption with small buffer reads

Thanks I will try asap. I have also cc'ed
Denys which had opened bug #10421


