Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXAVVda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXAVVda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXAVVda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:33:30 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:42518 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXAVVd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:33:29 -0500
In-Reply-To: <adaps96n4rl.fsf@cisco.com>
Subject: Re: [PATCH 2.6.20 2/2] ehca: ehca_irq.c: fix mismatched spin_unlock	in irq
 handler
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linuxppc-dev-bounces+hnguyen=de.ibm.com@ozlabs.org,
       openfabrics-ewg@openib.org, openib-general@openib.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF28705E47.AADA4E8C-ONC125726B.00756FD8-8525726B.00766A6A@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Mon, 22 Jan 2007 16:33:25 -0500
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 22/01/2007 22:33:26
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the right thing to do is restructure this function so you
> don't have lines starting 6 tab stops to the right.
Yes. Have reworked this irq handler and still struggling with testing.
When we feel comfortable with the test result, we'll post it here (soon)
and hopefully it is easier to read.
Regards
Nam

