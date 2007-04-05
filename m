Return-Path: <linux-kernel-owner+w=401wt.eu-S1946072AbXDEIDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946072AbXDEIDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946069AbXDEID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:03:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52442 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946072AbXDEIDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:03:25 -0400
Message-ID: <4614AD48.1080005@pobox.com>
Date: Thu, 05 Apr 2007 04:03:20 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com> <460B0539.9040103@pobox.com> <460B1F6B.5050108@gmail.com> <460B2249.4010200@pobox.com> <460B26AB.8060307@gmail.com>
In-Reply-To: <460B26AB.8060307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> AN is a generic concept that I feel will propagate elsewhere.
> 
> I think SCSI already has it or am I imagining things again?  :-)
> 
>> Though perhaps it should be in a 'capability_flags' file rather than a 
>> 'media_change_event' file.
> 
> IMHO, if it's genhd.capability_flags then the flag should be 
> MEDIA_CHANGE_NOTIFY not ASYNC_NOTIFICATION because AN itself doesn't 
> imply any specific event.  It's just a notification mechanism, for ATAPI 
> devices, it means media change, for PMP it has a different meaning, so I 
> think we need to export the processed meaning not the specific mechanism 
> to userland.

Agreed, sounds good.

	Jeff



