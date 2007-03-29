Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXC2Ciq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXC2Ciq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 22:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXC2Cip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 22:38:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49426 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXC2Cio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 22:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Jc9JsufPtbkbFNW0NEvTfByi1A0F1gV05GTk3FC70gDRCm9Q5xVI/VOBiNxA7fbhIRE6TvqvP5FJZfBatM1asz/P3VWe87pcvuF8GVsYvlZKv2r1j3jTx+Q9kHc28RAs2OUYFwfWF9R7X/Yw+EaKTem+r1sdY5ACImRB0jGgPAU=
Message-ID: <460B26AB.8060307@gmail.com>
Date: Thu, 29 Mar 2007 11:38:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com> <460B0539.9040103@pobox.com> <460B1F6B.5050108@gmail.com> <460B2249.4010200@pobox.com>
In-Reply-To: <460B2249.4010200@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> AN is a generic concept that I feel will propagate elsewhere.

I think SCSI already has it or am I imagining things again?  :-)

> Though perhaps it should be in a 'capability_flags' file rather than a 
> 'media_change_event' file.

IMHO, if it's genhd.capability_flags then the flag should be 
MEDIA_CHANGE_NOTIFY not ASYNC_NOTIFICATION because AN itself doesn't 
imply any specific event.  It's just a notification mechanism, for ATAPI 
devices, it means media change, for PMP it has a different meaning, so I 
think we need to export the processed meaning not the specific mechanism 
to userland.

Thanks.

-- 
tejun
