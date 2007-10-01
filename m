Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJAOy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJAOy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXJAOyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:54:17 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:29822 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXJAOyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:54:16 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] ehea: DLPAR memory add fix
Date: Mon, 1 Oct 2007 16:54:13 +0200
User-Agent: KMail/1.8.2
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710011633.18305.ossthema@de.ibm.com> <470107D9.2040301@garzik.org>
In-Reply-To: <470107D9.2040301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011654.14067.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 01 October 2007 16:44, Jeff Garzik wrote:
> Jan-Bernd Themann wrote:
> > Due to stability issues in high load situations the HW queue handling
> > has to be changed. The HW queues are now stopped and restarted again instead
> > of destroying and allocating new HW queues. 
> > 
> > Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> May I presume this is for 2.6.23?
> 
> 	Jeff

no, the patch is build against 2.6.24 upstream (new NAPI interface).

Regards,
Jan-Bernd
