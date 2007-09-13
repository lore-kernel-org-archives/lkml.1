Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXIMJtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXIMJtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXIMJtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:49:36 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55532 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXIMJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:49:35 -0400
In-Reply-To: <adaps0nmbfa.fsf@cisco.com>
References: <200709121439.32641.fenkes@de.ibm.com> <adaps0nmbfa.fsf@cisco.com>
Subject: Re: [PATCH] IB/ehca: Make sure user pages are from hugetlb before using MR
 large pages
To: Roland Dreier <rdreier@cisco.com>
Cc: "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <FENKES@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF2700619C.27B6141C-ONC1257355.00353BC8-C1257355.0035DE00@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Thu, 13 Sep 2007 11:49:19 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 13/09/2007 11:49:32
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote on 13.09.2007 06:33:45:

>
> Also if someone runs a kernel with 64K pages on a machine where they
> end up being simulated from 4K pages, do you have the same issue with
> the hypervisor ganging together non-contiguous pages?
With todays hypervisor and todays pagesizes and todays MMUs
we don't have this problem if eHCA is enabled.

It is difficult to make predictions about the future,
but that's not specific to driver development. ;-)

>
>  - R.

 - Christoph R.

