Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYKYNAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYKYNAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYKYM77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:59:59 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:60031 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYKYM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:59:59 -0500
In-Reply-To: <200811220020.30658.rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] cpumask: use new cpumask API in drivers/infiniband/hw/ehca
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Raisch <raisch@de.ibm.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFEB8798B7.9589F9FC-ONC125750C.0047594E-C125750C.00476863@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 25 Nov 2008 13:59:56 +0100
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 8.0.1|February 07, 2008) at
 25/11/2008 13:59:56
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Impact: cleanup
>
> We're moving from handing around cpumask_t's to handing around struct
> cpumask *'s.  cpus_*, cpumask_t and cpu_*_map are deprecated: convert
> to cpumask_*, cpu_*_mask.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Tested with latest kernel. Thanks for this!
Nam

