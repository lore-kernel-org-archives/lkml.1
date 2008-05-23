Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbYEWCxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbYEWCxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbYEWCxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:53:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:58528 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbYEWCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s+gtZRX3ooeNSmMNYfjIfRRUFtBVHTRMtplzCpgDrdnyiVrprlE43LoPKSnGHeOCqB8qdfgia7jSBXbiVEis2YiQ9wvhVm0VNLJY6+8KWNCz+VDYZQ4Pzxc2/Xg3p/sm9J6q1l0nQ/BNzJ4YqafQigijJ1H5MqVCrJwZrdYi6FQ=
Message-ID: <df9815e70805221953q42a6b96bm540dc56893053c27@mail.gmail.com>
Date: Fri, 23 May 2008 10:53:27 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: [PATCH] [.gitignore] match ncscope.out
Cc: sam@ravnborg.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0805212246390.15136@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4834CAFE.2070607@gmail.com>
	 <alpine.LNX.1.10.0805212246390.15136@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sounds reasonable.  As far as I know,  `ncscope*.out' is enough to
match all the cscope tmp files.

--
thanks and regards,
Jike

On Thu, May 22, 2008 at 4:47 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2008-05-22 03:23, Jike Song wrote:
>> ---
>> .gitignore |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/.gitignore b/.gitignore
>> index 090b293..a48b1e1 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -51,7 +51,7 @@ patches
>> series
>>
>> # cscope files
>> -cscope.*
>> +*cscope.*
>
> Unless you know there is acscope, bcscope, etc. I'd rather add
> just ncscope.* instead of the catches-more *cscope.*.
>
