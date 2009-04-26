Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZDZEMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZDZEMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 00:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZDZELv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 00:11:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35729 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbZDZELv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 00:11:51 -0400
Message-ID: <49F3DF02.5030909@garzik.org>
Date: Sun, 26 Apr 2009 00:11:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
References: <200904251509.11912.bzolnier@gmail.com> <49F3D994.7020304@kernel.org> <49F3DCD5.2070909@garzik.org> <49F3DE55.8070302@kernel.org>
In-Reply-To: <49F3DE55.8070302@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> Actually...  NVMHCI[1] uses the same style of id string extraction, even
>> though its command set is wholly new and unrelated to ATA.  I copied
>> into drivers/block/nvmhci.c[2] id_string, id_c_string and another
>> useful, generic routine: ata_wait_register.
>>
>> So, once nvmhci goes upstream, that will be a third copy...  nvmhci
>> still has rough edges, but it's mainly waiting on hardware "it works"
>> verification at this point.
> 
> For two copies, copying seems to be the right way to go.  For many
> more copies, making a library function is.  Three is a difficult
> number.  Maybe just make these inline functions for now?

<shrug>  I'm just adding some data, I don't have a good suggestion :)

The functions do not change very often, so three copies is not 
necessarily the end of the world.

	Jeff



