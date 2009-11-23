Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZKWQWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZKWQWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZKWQWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:22:05 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37319 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZKWQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SG66Sd7z9o5FqQQg25ZBXifbpiF3UxXf/UOK9UomShr1w8FiGucS4tIH/dujLNtYbG
         XpsFQTdGGKa2sB3cZsFVV+qnRnT99tWX65SIdYVleqMZ0xW6LOOkWVNBNVHzS8NRRXTF
         AlFW4gnNCrP4WU5Pi6U6aXnvcIb1PKt9KaijQ=
MIME-Version: 1.0
In-Reply-To: <20091123151946.GA3112@redhat.com>
References: <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
	 <20091120141840.GA5872@redhat.com>
	 <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
	 <20091120150421.GC5872@redhat.com>
	 <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
	 <20091120184257.GG5872@redhat.com>
	 <4e5e476b0911201150p7cbdfc20k4b8d02f07e16abc8@mail.gmail.com>
	 <4e5e476b0911210957g5b099329u33fa6ec4d740f7d1@mail.gmail.com>
	 <20091123151946.GA3112@redhat.com>
Date: Mon, 23 Nov 2009 17:22:09 +0100
Message-ID: <4e5e476b0911230822p4ddaf0cbv187c2bea29cba932@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Mon, Nov 23, 2009 at 4:19 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> This patch seems to be working much better in marking the random writer
> queue as sync and not interefere with sync-noidle workload.
>
> So frequent migration of random writer queue across group has stopped.
Great. I think this is good regardless of cgroups, to fix the fairness
issue regarding deep aio sync writers against random readers you
reported, so I'll send it to Jens.

> But there seems to be a different issue now after sometime, random writer
> queue stops generating enough traffic and gets deleted after one request
> and root group now runs random reader for sometime. So it basically
> changes the ratio in which random writers and random readers get disk
> share.
>
> I guess part of the dependency comes from kjournald which is in root
> group. But there is something else too because I don't see this happening
> when there are no cgroups. I will do more debugging on this.
Ok.

Thanks,
Corrado

> Thanks
> Vivek
>
