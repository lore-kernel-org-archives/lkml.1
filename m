Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYKMWlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYKMWlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYKMWlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:41:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:17305 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKMWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=k+RqRv6P6AF6vpQVXQ6Kt3PsG0m2M3N3ZiEDArn7WSgNRn6Il+2zPLAdjj3/FkTok9
         xvgrO1WTf0OYDEtLXOSwE4MjoogMhXbtqE8LJIlkeylUiaFO966NNhk6DT5SggYw4hVi
         C5HF50zL/XCGRghCuoYjd3MopuMwCnOwtKFiM=
Message-ID: <491C4A92.6060608@panasas.com>
Date: Thu, 13 Nov 2008 17:41:06 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: open-osd development <osd-dev@open-osd.org>,
       Christie <michaelc@cs.wisc.edu>,
       linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, Sami.Iren@seagate.com,
       Mike@cyclone.open-osd.org, linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 03/18 ver4] libosd: OSDv1 Headers
References: <491073BB.4000900@panasas.com>	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>	<4916F934.4090205@panasas.com>	<20081110092940.57b4c169.randy.dunlap@oracle.com>	<491AD697.9030305@panasas.com>	<20081112105945.f4ec0089.randy.dunlap@oracle.com>	<491C1CBF.6080504@panasas.com> <20081113101654.f2f25b1b.randy.dunlap@oracle.com>
In-Reply-To: <20081113101654.f2f25b1b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-and-liked-by me too :-)

Benny

On Nov. 13, 2008, 20:16 +0200, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 13 Nov 2008 14:25:35 +0200 Boaz Harrosh wrote:
> 
>> Headers only patch.
>>
>> osd_protocol.h
>> 	Contains a C-fied definition of the T10 OSD standard
>> osd_types.h
>> 	Contains CPU order common used types
>> osd_initiator.h
>> 	API definition of the osd_initiator library
>> osd_sec.h
>> 	Contains High level API for the security manager.
>>
>> [Note that checkpatch spews errors on things that are valid in this context
>> and will not be fixed]
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
> 
> OK by me.  Thanks for the changes.
> 
>> ---
>>  include/scsi/osd_initiator.h |  332 ++++++++++++++++++++++++++++
>>  include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++++++++++
>>  include/scsi/osd_sec.h       |   45 ++++
>>  include/scsi/osd_types.h     |   40 ++++
>>  4 files changed, 914 insertions(+), 0 deletions(-)
>>  create mode 100644 include/scsi/osd_initiator.h
>>  create mode 100644 include/scsi/osd_protocol.h
>>  create mode 100644 include/scsi/osd_sec.h
>>  create mode 100644 include/scsi/osd_types.h
> 
> ---
> ~Randy
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev

