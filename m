Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZDTP71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZDTP71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZDTP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:59:07 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:60495 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZDTP7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=skbf6GJ9/R8fcDNsYtxyE91nJxaXN+jzTxHVuokv6nRQhQKmtUrXN0ZddgpnKFewgG
         uhTONeSWXuiF4cfBEqN9ewda7YPl8BQdoht/BZFqiBk0quH2kOJughA3TaVLZutAywcn
         75j2KVxBM7jcNwGE6yOl0un5XlgIW7cJfhcaA=
MIME-Version: 1.0
In-Reply-To: <20090415143744.84d6c598.akpm@linux-foundation.org>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
	 <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
	 <200904120907.08828.ketuzsezr@darnok.org>
	 <20090415143744.84d6c598.akpm@linux-foundation.org>
Date: Mon, 20 Apr 2009 21:29:00 +0530
Message-ID: <81083a450904200859k40fcf14bvf780e6501fbcfebc@mail.gmail.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute 
	structure in sysfs
From: Ashutosh Naik <ashutosh.naik@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ketuzsezr@darnok.org, James.Bottomley@hansenpartnership.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       pjones@redhat.com, konradr@linux.vnet.ibm.com, vishnu@chelsio.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 3:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 12 Apr 2009 09:06:59 -0400
> Konrad Rzeszutek <ketuzsezr@darnok.org> wrote:
>
>> > The second question is who picks this up?  The drivers/firmware
>> > directory doesn't seem to have a dedicated tree, so I can take this
>> > through the SCSI tree if required or Andrew can take it through -mm.
>>
>> Which way works best for everybody? I was thinking SCSI, since the end result
>> of this module is to configure the storage used to bootstrap the box.
>
> I can merge merge it later this week.
>
> However...
>
>
> : From: Ashutosh Naik <ashutosh.naik@gmail.com>
> :
> : Fix the display of a few fields in the iBFT NIC attribute structure in
> : sysfs.
<snip>

> The changelog is bad.
>
> What does "fix" mean?  What does the old output look like and how does
> this patch change it?
>
> This matters, because this is a userspace interface and who knows, there
> might be applications out there which somehow depend on the old and
> broken behaviour.
>
> Of course, that might be totally silly and unrealistic but because we
> weren't told what the patch actually does, how can I tell?
>
> Please send a new and complete description of this change, thanks.

Sorry for the delay.

Here is an updated Changelog

The patch ensures that, if the DHCP IP address and the subnet mask for
the interface is present in the iBFT NIC structure, the corresponding
entries are created in sysfs tree for the device. This would hence
create the additional entries in the tree based on the iBFT table and
would not delete any existing entries.

Thanks.
