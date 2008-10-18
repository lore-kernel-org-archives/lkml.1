Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYJRPuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYJRPuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYJRPuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:50:22 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:17410 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYJRPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N/y53vQ769zxh6+XItI86AYWmMwYymubmbnzMcDIUksyH28DEktZux7qX3dv9bbNnr
         H5SNjXhUl4S9ynS9RNI208EzUeU/QoXDY9iW2HBFS0W50PweNsD+14WZqkOhouFRaO3N
         9HwIY6BxIXj8yN71hEdTL9/8p22fJBbPyjxxQ=
Message-ID: <a4423d670810180850w1e3845a5lf4dae12c0a001e3d@mail.gmail.com>
Date: Sat, 18 Oct 2008 19:50:17 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: 2.6.27-05178-g2e532d6: list_add corruption
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810180737100.21525@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810171220t4d5602fekcb66e18758149925@mail.gmail.com>
	 <Pine.LNX.4.64.0810171617490.21410@alien.or.mcafeemobile.com>
	 <a4423d670810172341y5ae5542jea66ead938ba652d@mail.gmail.com>
	 <Pine.LNX.4.64.0810180737100.21525@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Davide Libenzi <davidel@xmailserver.org>:
> On Sat, 18 Oct 2008, Alexander Beregalov wrote:
>
>> > This is very likely to be caused by a patch that went in a few days ago.
>> > Already posted a fix to Andrew.
>> >
>>
>> Is it the same problem? 2.6.27-05577-g0cfd810
>
> Hard to be sure, but certainly a double insert can create a similar
> problem. The only way to tell is to get the fix and retry.
I have already applied your patch and the kernel works better, no
errors anymore.
Thanks
