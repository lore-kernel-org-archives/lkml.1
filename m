Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYBASlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYBASlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYBASku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:40:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54890 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYBASks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:40:48 -0500
Message-ID: <47A367AE.8000004@garzik.org>
Date: Fri, 01 Feb 2008 13:40:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ehea: fix sysfs link compile problem
References: <200802011537.42578.ossthema@de.ibm.com>
In-Reply-To: <200802011537.42578.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Due to changes in the struct device_driver there is no direct
> access to its kobj any longer. The kobj was used to create
> sysfs links between eHEA ethernet devices and the driver.
> This patch removes the affected sysfs links to resolve
> the build problems.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> 
> ---
>  drivers/net/ehea/ehea_main.c |   37 -------------------------------------
>  1 files changed, 0 insertions(+), 37 deletions(-)

applied


