Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYLJBNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYLJBNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYLJBMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:12:54 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:53525 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYLJBMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wudOSMSm5vTDeSHtTYozmNyVVRhhAD+XQdLVK7fBLFglwLLLYxyl7t+XnzeIx9Juqj
         BzgXcDMS492vl7Wcva7RUZLH5pGfEAIGvTkAB5ReEBt/ua9JzStxz44FdT+Zn/HEZe4e
         g+hjRToIJUG0XhftcxklmrxB8FFTZXBiLzRdQ=
Message-ID: <2c0942db0812091712l5efa2d2dia9ff2e3d92f81bbc@mail.gmail.com>
Date: Tue, 9 Dec 2008 17:12:46 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>, pkpatel.lists@gmail.com
Subject: Re: Fwd: 2.6.26.3 kernel - progressive slowdown over NFS
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <1228871206.30231.76.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4e12c70809091747rd58165ahaa6594a35752c6ef@mail.gmail.com>
	 <2c0942db0812091638o3d0fe68ek70744f6938949b25@mail.gmail.com>
	 <1228871206.30231.76.camel@heimdal.trondhjem.org>
X-Google-Sender-Auth: 8de2ef99fe7e59ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sigh, adding back original reporter. Oops.  -- rbl ]

Priyank Patel, please see Trond's response below and try out the
suggested patch linked below.

On Tue, Dec 9, 2008 at 5:06 PM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
> On Tue, 2008-12-09 at 16:38 -0800, Ray Lee wrote:
>> [ adding netdev, linux-nfs to cc: -- rbl ]
>>
>> Hi,
>>
>>
>> We have a simple python program which keeps running a C loop to lstat
>> NFS mounted directories.  We are seeing some weird behavior w.r.t. the
>> run-time of this program on 2.6.26.3 kernel vs 2.6.24 kernel.
>>
>> The run-time of the following code increases over time on the 2.6.26.3
>> kernel, whereas remains flat (as expected) on the 2.6.24 kernel.
>> [See attached graphs - B1.jpg and B2.jpg]  Once the 2.6.26.3 machine
>> gets into this state, we need to restart the box to get back to
>> reasonable run-times.  Is this a known issue ?
>
> Could you try applying the following patch?
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=23918b03060f6e572168fdde1798a905679d2e06
>
> Trond
>
> PS: note that your 2.6.26 config file has _very_ different memory models
> and kernel debugging options enabled compared to your 2.6.24 kernel.
> That may also affect performance.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
