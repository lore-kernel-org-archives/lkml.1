Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZFPRDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZFPRDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZFPRDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:03:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:33278 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFPRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:03:32 -0400
Message-ID: <4A37D073.6020802@freescale.com>
Date: Tue, 16 Jun 2009 12:03:47 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Chris Pringle <chris.pringle@oxtel.com>
CC: linux-kernel@vger.kernel.org,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com> <20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com> <4A37CC72.3060709@freescale.com> <4A37CF02.5080906@oxtel.com>
In-Reply-To: <4A37CF02.5080906@oxtel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Pringle wrote:
> Ah right - that would explain what we're seeing then... Doh. Thought I 
> might have been onto something then. Is there any way to force a cache 
> flush? That'd at least prove it was a caching issue if it resolved the 
> problem.

You could enable CONFIG_NOT_COHERENT_CACHE.

-Scott
