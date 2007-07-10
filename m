Return-Path: <linux-kernel-owner+w=401wt.eu-S1763221AbXGJRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221AbXGJRAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbXGJRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:00:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60411 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbXGJRAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:00:20 -0400
Message-ID: <4693BB22.5070303@garzik.org>
Date: Tue, 10 Jul 2007 13:00:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2/2] eHEA: Receive SKB Aggregation
References: <200707041209.48658.ossthema@de.ibm.com>
In-Reply-To: <200707041209.48658.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch enables the receive side processing to aggregate TCP packets within
> the HEA device driver. It analyses the packets already received after an
> interrupt arrived and forwards these as chains of SKBs for the same TCP
> connection with modified header field. We have seen a lower CPU load and
> improved throughput for small numbers of parallel TCP connections.
> As this feature is considered as experimental it is switched off by default
> and can be activated via a module parameter.
> 
> Some additional security checks have been added since the last posting.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

as noted in comments, we don't need to recreate this in every driver. 
do something more generic.


