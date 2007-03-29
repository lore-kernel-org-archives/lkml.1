Return-Path: <linux-kernel-owner+w=401wt.eu-S965886AbXC2BxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbXC2BxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965890AbXC2BxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:53:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36099 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965886AbXC2BxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dLwv1PXdbiSYxQWoRJ6zcXhGBepoOW9IB0DW6YuROD/GRxkiXCs3uZXTVIVF5j1J6LCL7ZJcrZBZ7bdGUekRQjOrPeu3b4Eh2+0Vo8ptXjVej0kNt1nbGBn0+oGKYAXfLXCSceSTbBs2gmJTT7gRW2imHtTfVTtgVymT0lymMQ8=
Message-ID: <460B1C06.6040808@gmail.com>
Date: Thu, 29 Mar 2007 10:53:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [patch 1/3] libata: check for AN support
References: <20070328230108.597741522@intel.com> <20070328164443.9fc8b924.kristen.c.accardi@intel.com>
In-Reply-To: <20070328164443.9fc8b924.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Check to see if an ATAPI device supports Asynchronous Notification.
> If so, enable it.

As supporting AN needs host interrupt handler change.  I think we need 
host-supports-AN flag; otherwise, we might end up with screaming 
interrupts in the worst case.

-- 
tejun
