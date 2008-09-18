Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYIRXxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYIRXxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYIRXxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:53:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59350 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYIRXxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=XeoXCtdNfUDmavexMZInQsyi4ZxkqfQOpJb0tL2KOZZocwgtaXBWMj3uSrk9Y6lwXf
         EtJmy5fA+A9Wr7XevHfAs45E+Cn5cLB/BHwT1c8HncZRcSSNFdDYtU8B1QqIfh5g8F7h
         WvQEy+SpuC3vJ+IliG/4A0FTNCJOHgPSH0SFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/4 v2] Introduce ata_id_has_unload()
Date: Thu, 18 Sep 2008 16:24:11 -0700
User-Agent: KMail/1.9.9
Cc: Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <20080917163144.9870.90985.stgit@denkblock.local> <48D13712.1090904@gmail.com>
In-Reply-To: <48D13712.1090904@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809181624.11949.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 09:57:54 Tejun Heo wrote:
> Elias Oltmanns wrote:
> > Add a function to check an ATA device's id for head unload support as
> > specified in ATA-7.
> > 
> > Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Since there are still some minor concerns with libata version while
the ide one is completely ready I applied this patch to pata tree in
order not to delay wider testing anylonger.

Thanks,
Bart
