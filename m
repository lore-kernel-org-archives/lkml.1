Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZKTN3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZKTN3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZKTN3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:29:50 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39927 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZKTN3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KVr349hUh6nXDGbA6QySaurtybav97ILVcCwKTbTv0BFnxur1TIsQ0s1CUWDmtXr33
         SRxjUjOjDpEVRQ1nCngou7ELuynhxmjYUu3/1t0XLR2eqMUiy7HRi7PZqDA443yCfl2D
         jC893TDRgm+w6ZHiNVSRWj1hetcApZzAm9pJ0=
MIME-Version: 1.0
In-Reply-To: <4B01577E.2020003@chelsio.com>
References: <4B014F95.8000906@chelsio.com>
	 <20091116.051835.125328285.davem@davemloft.net>
	 <4B01577E.2020003@chelsio.com>
Date: Fri, 20 Nov 2009 15:29:24 +0200
Message-ID: <b263e5900911200529n1c002097q48a625d1bcda4db6@mail.gmail.com>
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
From: Dan Carpenter <error27.lkml@gmail.com>
To: Rakesh Ranjan <rakesh@chelsio.com>
Cc: David Miller <davem@davemloft.net>, michaelc@cs.wisc.edu,
       open-iscsi@googlegroups.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de, kxie@chelsio.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/09, Rakesh Ranjan <rakesh@chelsio.com> wrote:
> David Miller wrote:
>> From: Rakesh Ranjan <rakesh@chelsio.com>
>> Date: Mon, 16 Nov 2009 18:41:49 +0530
>>
>>> Herein attached patches to support dhcp based provisioning for iSCSI
>>> offload capable cards. I have made dhcp code as generic as possible,
>>> please go through the code. Based on the feedback I will submit final
>>> version of these patches.
>>
>> You can't really add objects to the build before the patch that
>> adds the source for that object.
>>
>
> Hi david,
>
> Fixed patch attached.
>
> Regards
> Rakesh Ranjan
>

The header file changes cause warnings in allmodconfig.

   CC [M]  drivers/scsi/be2iscsi/be_iscsi.o
+In file included from drivers/scsi/be2iscsi/be_iscsi.c:21:
+include/scsi/libiscsi.h:445: warning: ‘struct net_device’ declared
inside parameter list
+include/scsi/libiscsi.h:445: warning: its scope is only this
definition or declaration, which is probably not what you want
+include/scsi/libiscsi.h:447: warning: ‘struct sk_buff’ declared
inside parameter list
+include/scsi/libiscsi.h:447: warning: ‘struct net_device’ declared
inside parameter list

regards,
dan carpenter
