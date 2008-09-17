Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYIQVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYIQVtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbYIQVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:48:57 -0400
Received: from pih-relay04.plus.net ([212.159.14.17]:44442 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYIQVs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:48:56 -0400
Message-ID: <48D17B47.7080704@yahoo.com>
Date: Wed, 17 Sep 2008 22:48:55 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no> <fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no>
In-Reply-To: <fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 71efaa7fcf140e0364b895548fb3757a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> this says you haven't done "make install" on the latencytop directory
> so it's not translating things for you.. can you do that please?

> Cause                                                Maximum     Percentage
> Scheduler: waiting for cpu                        208.3 msec         59.4 %
> Userspace lock contention                           4.9 msec         29.7 %
> Waiting for event (poll)                            4.8 msec          7.1 %
> Waiting for event (select)                          4.5 msec          0.6 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_re  1.9 msec          2.0 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.7 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.6 %
> Executing raw SCSI command                          0.7 msec          0.0 %
> ex_resolve_to_value
> 
> 
> 
> 
> 
> Process firefox-bin (5756)                 Total: 317.2 msec                                                                 
> Scheduler: waiting for cpu                        208.3 msec         96.4 %
> Waiting for event (poll)                            3.7 msec          3.0 %
> Userspace lock contention                           1.0 msec          0.7 %
> 
> 
> 
> 
> 
> 
> 
> 
>  pdflush  gnome-vfs-daemo  bash  top  bash  pulseaudio  gconf-helper  bash  rhythmbox  firefox  run-mozilla.sh  firefox-bin 

Better?

