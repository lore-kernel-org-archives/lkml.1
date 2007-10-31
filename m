Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbXJaFR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbXJaFR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXJaFRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:17:48 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:30929 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXJaFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:17:47 -0400
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="411915774"
To: "Shawn Jin" <shawnxjin@gmail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI messages support
X-Message-Flag: Warning: May contain useful information
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
	<4727AED2.6010908@garzik.org> <adaejfci5cz.fsf@cisco.com>
	<4727FDC3.8010407@garzik.org>
	<c3d0340b0710302205i7129f78bq9a4af7744ee60b6d@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Oct 2007 22:17:42 -0700
In-Reply-To: <c3d0340b0710302205i7129f78bq9a4af7744ee60b6d@mail.gmail.com> (Shawn Jin's message of "Tue, 30 Oct 2007 21:05:36 -0800")
Message-ID: <ada1wbbj215.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Oct 2007 05:17:42.0862 (UTC) FILETIME=[5D3426E0:01C81B7D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > My interpretation of this statement is that you have to use MSIX if
 > multiple MSI messages are required on Linux.

Yes, Linux only supports multiple messages with MSI-X, not MSI.  This
is an architectural limitation of "Intel-style" interrupt controllers
(x86 and ia64).  It is also a limitation of the Linux's MSI API, since
there are platforms and devices for which an OS could allocate
multiple MSI messages, but Linux has no interface that allows that.

The historical reason for the Linux interface is simply that Intel
platforms were the first place that MSI/MSI-X was supported.

 - R.
