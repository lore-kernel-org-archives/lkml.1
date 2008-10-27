Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYJ0Swv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYJ0Swv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJ0Swk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:52:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53085 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYJ0Swj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:52:39 -0400
Message-ID: <49060DF0.6040607@garzik.org>
Date: Mon, 27 Oct 2008 14:52:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Thomas Klein <tklein@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>, Hannes Hering <hering2@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       badari@us.ibm.com, haveblue@us.ibm.com, tollefso@us.ibm.com
Subject: Re: [PATCH] ehea: Add hugepage detection
References: <200810271038.46825.tklein@de.ibm.com>
In-Reply-To: <200810271038.46825.tklein@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> All kernel memory which is used for kernel/hardware data transfer must be registered
> with firmware using "memory regions". 16GB hugepages may not be part of a memory region
> due to firmware restrictions.
> This patch modifies the walk_memory_resource callback fn to filter hugepages and add
> only standard memory to the busmap which is later on used for MR registration.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> This reworked patch accounts for comments I got. It's based on davem's net-2.6.git.

applied


