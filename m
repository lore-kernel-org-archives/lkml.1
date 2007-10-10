Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbXJJAjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbXJJAjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXJJAjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:39:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39083 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXJJAjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:39:39 -0400
Message-ID: <470C1F43.7050608@garzik.org>
Date: Tue, 09 Oct 2007 20:39:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] ehea: use kernel event queue
References: <200710081601.34067.ossthema@de.ibm.com>
In-Reply-To: <200710081601.34067.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> eHEA recovery and DLPAR functions are called seldomly. The eHEA workqueues
> are replaced by the kernel event queue.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> ---
> The patch has been built against upstream git
> 
>  drivers/net/ehea/ehea.h      |    3 +--
>  drivers/net/ehea/ehea_main.c |   28 ++++++++--------------------
>  drivers/net/ehea/ehea_qmr.c  |    3 +--
>  3 files changed, 10 insertions(+), 24 deletions(-)

applied


