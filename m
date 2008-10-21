Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYJUGLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYJUGLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYJUGL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:11:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46205 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYJUGL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:11:27 -0400
Message-ID: <48FD728A.2090504@garzik.org>
Date: Tue, 21 Oct 2008 02:11:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH] ehea: Fix memory hotplug support
References: <200809171619.46741.hannes.hering@linux.vnet.ibm.com> <200810151318.59151.hannes.hering@linux.vnet.ibm.com> <48F7056F.7050602@garzik.org> <200810161136.42822.hannes.hering@linux.vnet.ibm.com>
In-Reply-To: <200810161136.42822.hannes.hering@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering wrote:
> This patch implements the memory notifier to update the busmap instantly
> instead of rebuilding the whole map. This is necessary because
> walk_memory_resource provides different information than required during memory
> hotplug.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> ---
> Jeff, as requested, this patch is now based on davem's net-2.6.git.

applied


