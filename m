Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXG3Ovf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXG3Ovf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXG3Ov0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:51:26 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:21477 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbXG3OvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:51:25 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/5] ehca: Generate event when SRQ limit reached
Date: Mon, 30 Jul 2007 17:02:59 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, raisch@de.ibm.com, stefan.roscher@de.ibm.com,
       fenkes@de.ibm.com
References: <200707201602.19142.hnguyen@linux.vnet.ibm.com> <ada7iou75tn.fsf@cisco.com>
In-Reply-To: <ada7iou75tn.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301703.00111.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> BTW, does your SRQ-capable hardware support generating the "last WQE
> reached" event?  There's not any reliable way to avoid problems when
> destroying QPs attached to an SRQ without it, and the IB spec requires
> CAs that support SRQs to generate it (o11-5.2.5 in chapter 11 of vol 1).
> 
> I don't see any code in ehca to generate the event, and IPoIB CM at
> least will be very unhappy when using SRQs if the event is not
> generated.
Thanks for this good catch. We're investigating how to implement this.
Will keep you updated.
Regards
Nam

