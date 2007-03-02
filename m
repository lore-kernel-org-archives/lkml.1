Return-Path: <linux-kernel-owner+w=401wt.eu-S1422650AbXCBIdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650AbXCBIdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422657AbXCBIdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:33:45 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:32286 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422650AbXCBIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:33:45 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2.6.21-rc2] ehca: fix mismatched sync between completion handler and destroy cq
Date: Fri, 2 Mar 2007 09:37:46 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, hch@infradead.org, raisch@de.ibm.com,
       heiko.carstens@de.ibm.com
References: <200702281801.02747.hnguyen@linux.vnet.ibm.com> <ada8xegr7zu.fsf@cisco.com>
In-Reply-To: <ada8xegr7zu.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703020937.47012.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > +#include <linux/completion.h>
> This can just be <linux/wait.h>, because you're only using
> wait_queue_head_t and not struct completion, right?
> I fixed this up before merging.
Yes, right. Thanks for your help!
Regards
Nam 

