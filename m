Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZDVPXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZDVPXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZDVPWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:22:52 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51519 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZDVPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eDkYW/VpqcEKocs2GfMQO7p/4t4w7VWEZJ989e83UWY8YDhy7k19uawwxACzPG88vs
         mqC10omtodlmy6Blem7IHm0FvSTIQiUqEwyGEev+vlUVcaKEZvJehBXyqtwj2tIVMe34
         aUYMZfg5j627qL176umM4u6tz2AUg5ztdAkCo=
MIME-Version: 1.0
In-Reply-To: <20090422161257.2743ea33@lxorguk.ukuu.org.uk>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
	 <871vrkpyae.fsf@basil.nowhere.org>
	 <f44001920904220732h2d6d18cfwef53af31bb218b87@mail.gmail.com>
	 <f44001920904220746k356550abk6783b8cae003685d@mail.gmail.com>
	 <20090422161257.2743ea33@lxorguk.ukuu.org.uk>
Date: Wed, 22 Apr 2009 19:22:49 +0400
Message-ID: <f44001920904220822k672def82t7e9ba646bdde5fe8@mail.gmail.com>
Subject: Re: Idea: Feature information / extensions dispatcher syscall.
From: Igor Zhbanov <izh1979@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> But in some cases syscalls are more convenient than reading/writing/ioctling
>> in /proc, /sys or /dev.
>
> A syscall and an ioctl are the same thing except that you need a file
> handle for one of them.
>
>> And I suggest to regulate syscalls usage and reserve a set of numbers
>> "home" modules used in some organizations only.
>
> We have file system naming so you can open device or sysfs and the like
> files to do that job. That avoids the problem of trying to keep numbering
> sane.

Yes, you need a file handle. To open device each time you need to make ioctl
is expensive and keeping device opened may prevent unmounting /proc
that could be a problem in some installations if that application is used
at a boot time.
