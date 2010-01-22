Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928Ab0AVDH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0AVDH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920Ab0AVDH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:07:26 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48278 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab0AVDHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iiP+tgPY+JKruxeAXQLDjhoDDeBxlc59QqUVzq+UfebK5kmW4kQrLo1bHRntO82ggy
         4AmZHZBeO8M8xcJN0aG4AH2LNO5FfM5uOkj6No8s8d0N8Rsc9RbOYP5wdAZrp9IsGGp5
         bEX71hZWSe8PRd9xXlk7K0WtFQrF+E4VnVBtY=
MIME-Version: 1.0
In-Reply-To: <20100120152652.GA3595@hack>
References: <de04351e1001200320y2e763680gc7e3b20319c6386e@mail.gmail.com>
	 <20100120152652.GA3595@hack>
Date: Fri, 22 Jan 2010 11:07:23 +0800
Message-ID: <de04351e1001211907m4ff30a24ubf338fbd0bd1d086@mail.gmail.com>
Subject: Re: nfs-error-RPC: multiple fragments per record not supported
From: jin zhencheng <zhenchengjin@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       zhenchengjin@163.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried  'ethtool -K eth0 tso off' ,but my system also have  the
same errors

do someone know how to resolve  ?

RPC: multiple fragments per record not supported
RPC: multiple fragments per record not supported
RPC: fragment too large: 0x318c87ee
RPC: multiple fragments per record not supported



On Wed, Jan 20, 2010 at 11:26 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Jan 20, 2010 at 07:20:34PM +0800, jin zhencheng wrote:
>>I use kernel 2.6.26.2
>>
>>I use  29 clients,
>>
>>every client mount parameters as this: mount -t nfs -o
>>rw,noatime,v3,rsize=32768,wsize=32768,hard,intr,tcp,nolock
>>
>>my system have many errors lke these :
>>
>>RPC: multiple fragments per record not supported
>>RPC: multiple fragments per record not supported
>>RPC: fragment too large: 0x318c87ee
>>RPC: multiple fragments per record not supported
>>RPC: fragment too large: 0x78bdeedb
>>RPC: multiple fragments per record not supported
>>RPC: fragment too large: 0x75cf8a33
>>RPC: fragment too large: 0x44764ada
>>RPC: multiple fragments per record not supported
>>RPC: fragment too large: 0x0a08e7c0
>>RPC: multiple fragments per record not supported
>>RPC: multiple fragments per record not supported
>>RPC: fragment too large: 0x5b4e13a1
>>RPC: fragment too large: 0x08351a9f
>>
>
> Does 'ethtool -K eth0 tso off' help?
>
> --
> Live like a child, think like the god.
>
>
