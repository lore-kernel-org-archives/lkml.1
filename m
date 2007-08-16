Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbXHPQsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbXHPQsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764953AbXHPQsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:48:23 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47346 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764973AbXHPQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:48:22 -0400
In-Reply-To: <adatzqz1mjx.fsf@cisco.com>
Subject: Re: [ofa-general] [PATCH 7/7] IB/ehca: Prevent overwriting QP init
	attributes given by caller
To: Roland Dreier <rdreier@cisco.com>
Cc: general-bounces@lists.openfabrics.org, Joachim Fenkes <fenkes@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF50DCEF62.940E3D7F-ONC1257339.005C150A-C1257339.005C4CA8@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Thu, 16 Aug 2007 18:48:18 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 16/08/2007 18:48:18
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

general-bounces@lists.openfabrics.org wrote on 16.08.2007 18:17:22:

> I don't understand this patch.  <rdma/ib_verbs.h> says this about
> ib_create_qp():
>
>  * @qp_init_attr: A list of initial attributes required to create the
>  *   QP.  If QP creation succeeds, then the attributes are updated to
>  *   the actual capabilities of the created QP.
>
> So it seems the current code is actually correct and your patch breaks
> it??
Yes. That's absolutely true. Please ignore it.
Thanks!
Nam

