Return-Path: <linux-kernel-owner+w=401wt.eu-S1765953AbYEFJaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765953AbYEFJaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbYEFJ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:27:48 -0400
Received: from bay0-omc1-s27.bay0.hotmail.com ([65.54.246.99]:48750 "EHLO
	bay0-omc1-s27.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765689AbYEFJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:27:46 -0400
Message-ID: <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "David Chinner" <dgc@sgi.com>
Cc: "David Chinner" <dgc@sgi.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Tue, 6 May 2008 11:25:21 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 06 May 2008 09:27:46.0132 (UTC) FILETIME=[71827940:01C8AF5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:

> Hmmmmm - interesting. Both the reports of this problem are from
> machines running as squid proxies. Are you using AUFS for the cache?

no, I'm using cache_dir ufs with cache_replacement_policy heap LFUDA

> You've run repair, there's not much I can look at now.
>
> As a suggestion, when the cache gets close to full next time, can
> you take a metadump of the filesystem (obfuscates names and contains
> no data) and then trigger the cache cleanup function? If the
> filesystem falls over, I'd be very interested in getting a copy of
> hte metadump image and trying to reproduce the problem locally.
> (BTW, you'll need a newer xfsprogs to get xfs_metadump).

could you please tell me the exact command to run
when this happen again?

> Still, thank you for the information

no problem: 2.6.25 is a bit unlucky for me :-((



