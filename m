Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZHUIOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZHUIOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZHUIOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:14:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100AbZHUIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:14:49 -0400
Date: Fri, 21 Aug 2009 04:14:47 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Gianluca Guida <gianluca.guida@citrix.com>
Message-ID: <1378245818.61101250842487688.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1152394510.61021250842386600.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
From: "Jeremy Fitzhardinge" <jeremy@goop.org>
To: "Miroslav Rezanina" <mrezanin@redhat.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, "Gianluca Guida" <gianluca.guida@citrix.com>
Sent: Thursday, August 20, 2009 6:39:02 PM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor

On 08/20/09 00:47, Miroslav Rezanina wrote:
>> there is handled e820 map in guest. However, this patch informs 
>> hypervisor, that guest uses less memory than was assigned to it. 
>> If hypervisor is not informed, memory is reserved for guest that
>> do not need it. If hypervisor is informed, he decrease memory
>> reservation for guest and unused memory is marked as free 
>> for use by other guests.
>>   
>
> Yes.  But the guest will modify its own e820 map for a number of
> reasons; for example: reducing its own memory, or clearing a space for
> the PCI hole.  In general we want to free any underlying pages which
> don't correspond to E820_RAM regions.
>
>    J

I agree. However, I'm not sure if xen supports such a precise handling.
  
-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

