Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZJ2KDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZJ2KDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJ2KDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:03:19 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:41766 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZJ2KDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V0GFYdS47LQHqXX4B797SJ1oGgk9MNa2xXci+Bmtq6+M7JZuRD6aFRclhijlIuRDbt
         He3tvLG5JpM4FbKkfW1LWa1bhOv4OtieIgObJR7xFaTHJu23iJYnvxeVltNQTh86teij
         s4HXtET8BXP0msBShOW1PbeaNFhjjQXDxYayY=
MIME-Version: 1.0
In-Reply-To: <4AE9430B.3060105@suse.de>
References: <86802c440910281313h2ca89c94w99121edffbf6ce53@mail.gmail.com>
	 <4AE9430B.3060105@suse.de>
Date: Thu, 29 Oct 2009 03:03:23 -0700
Message-ID: <86802c440910290303y787c539cp98f400400fe9a243@mail.gmail.com>
Subject: Re: nfs broken in net-next?
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 12:23 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> On 10/29/2009 01:43 AM, Yinghai Lu wrote:
>> pk12-3214-189-102:~ # mount -t nfs 10.6.75.100:/data/shared/pxeboot /x
>> mount.nfs: rpc.statd is not running but is required for remote locking.
>> mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
>
> rpc.statd on client should have be started by mount.nfs when a nfs
> filesystem is mounted. Is this not happening for some reason or do you
> see any errors in syslog?
>
>>
>> using opensuse11.1
>>
>
> Are you using 11.1 betas? I know of a problem where non-root user mounts
> fail to start rpc.statd in betas that got fixed later:
>
> http://marc.info/?l=linux-nfs&m=122748525624094&w=2
>
> Is the problem seen only recently (after updating to net-next)?
>

only happen with net-next.

linus tree and tip tree are ok.

YH
