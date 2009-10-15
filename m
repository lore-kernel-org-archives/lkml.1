Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbZJOTdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbZJOTdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbZJOTdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:33:06 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57938 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZJOTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:33:04 -0400
Message-ID: <4AD778E6.7020806@freescale.com>
Date: Thu, 15 Oct 2009 14:32:54 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linuxppc-dev@ozlabs.org, brueckner@linux.vnet.ibm.com,
       Timur Tabi <timur@freescale.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
References: <1255557226-4403-1-git-send-email-timur@freescale.com>	<200910152041.26646.borntraeger@de.ibm.com>	<4AD770A9.6070509@freescale.com> <200910152126.28024.borntraeger@de.ibm.com>
In-Reply-To: <200910152126.28024.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 19:32:27.0664 (UTC) FILETIME=[3AAF2900:01CA4DCE]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> About the backends, there are some that spin until the text is delivered (e.g. 
> virtio) , others can drop (e.g. iucv is a connection oriented protocol and it 
> will (and has to) drop if there is no connection). 

Sure, dropping due to not having a connection makes sense.  That's 
different from merely being busy.  Can the iucv code tell the difference 
between those two states?

-Scott
