Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKYM7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKYM7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 07:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYKYM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:59:13 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:41188 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYKYM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:59:13 -0500
In-Reply-To: <200811220020.07407.rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] cpumask: use for_each_online_cpu() in drivers/infiniband/hw/ehca/ehca_irq.c
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Raisch <raisch@de.ibm.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFF6EEC56C.8E19F99D-ONC125750C.00471224-C125750C.00475612@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 25 Nov 2008 13:59:09 +0100
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 8.0.1|February 07, 2008) at
 25/11/2008 13:59:10
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Impact: cleanup
>
> In future, accessing cpu numbers beyond nr_cpu_ids (the runtime limit)
> will be undefined.  We can avoid future problems by using
> for_each_online_cpu() here.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Tested with latest kernel. Thanks for this!
Nam

