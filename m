Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYFWLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYFWLh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYFWLhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:37:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:62960 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYFWLhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=FkBkRWZYBSuVtj0GZ6St3Vku4pSO2JPLhT4qYtyNys0ZkR9Y4BWYp2x2GhizwjhUGW
         g8M+OJsxdQLg3o6MKJRjadvPBlvQ4oLhhM1PNPSpM/cGcEWVkyJTI1c93mORTeLP4DtT
         kF9Ev866787FcO5N4orTpRq/dgcLcp6Oz2FHQ=
Message-ID: <7c86c4470806230437i55961d08g7416ad1a65203b8c@mail.gmail.com>
Date: Mon, 23 Jun 2008 13:37:16 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 02/19] perfmon2 minimal v2: base code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080623120053.25de0173.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48583462.25014e0a.0982.6263@mx.google.com>
	 <20080623120053.25de0173.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

This is a good comment. I check the perfmon subdir and there is indeed
no need to go
there when CONFIG_PERFMON is not set. I have made the change now.

Thanks.


On Mon, Jun 23, 2008 at 4:00 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Stephane,
>
> On Tue, 17 Jun 2008 15:02:10 -0700 (PDT) eranian@googlemail.com wrote:
>>
>> +++ o/perfmon/Makefile        2008-06-17 08:33:23.000000000 +0200
>> @@ -0,0 +1,7 @@
>> +#
>> +# Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
>> +# Contributed by Stephane Eranian <eranian@gmail.com>
>> +#
>> +obj-$(CONFIG_PERFMON) = perfmon_ctx.o \
>> +                     perfmon_file.o perfmon_attach.o         \
>> +                     perfmon_res.o perfmon_init.o
>
>> +++ o/Makefile        2008-06-17 08:34:19.000000000 +0200
>> @@ -607,7 +607,7 @@
>>
>>
>>  ifeq ($(KBUILD_EXTMOD),)
>> -core-y               += kernel/ mm/ fs/ ipc/ security/ crypto/ block/
>> +core-y               += kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/
>
> Is there some reason that this is not
>
> core-$(CONFIG_PERFMON)  += perfmon/
>
> and then you could just use "obj-y" in perfmon/Makefile
>
> Or are there going to be things in perfmon/ that need building if
> CONFIG_PERFMON is not set?
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
