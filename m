Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYGDMOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYGDMOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYGDMOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:14:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48121 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYGDMOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:14:30 -0400
Message-ID: <486E141F.6070108@garzik.org>
Date: Fri, 04 Jul 2008 08:14:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, kamalesh@linux.vnet.ibm.com,
       hering2@de.ibm.com
Subject: Re: [PATCH 1/3] ehea: fix might sleep problem
References: <200807031618.46087.ossthema@de.ibm.com>
In-Reply-To: <200807031618.46087.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> A mutex has to be replaced by spinlocks as it can be called from
> a context which does not allow sleeping.
> The kzalloc flag GFP_KERNEL has to be replaced by GFP_ATOMIC
> for the same reason.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied 1-3 to 2.6.26


