Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbZLGOqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbZLGOqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZLGOqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:46:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46403 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZLGOqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KaBD7Dd7tIt9AQMR4qARfpTGT6msudnDIlQbFMvJEVKzYG5fw6BXxnSQKR1h8gbhHy
         H0J+Se6ANY1GWftfRg3dIe35arBHFxX77ObL07fXkUBMZbvX3KSXtcDBjPTCzn/Yc44K
         GZtDGjTYw2Mnlyx1qEIuLr7OniRfl/N54LT7c=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912070648330.2285@localhost>
References: <82cfbe860912070340k6c1a3560u14e4f628f8202b23@mail.gmail.com>
	 <alpine.LFD.2.00.0912070648330.2285@localhost>
Date: Mon, 7 Dec 2009 16:40:36 +0200
Message-ID: <82cfbe860912070640k6a6f6ed8ia62365b35353f079@mail.gmail.com>
Subject: Re: Sun-java5-sdk installing
From: tarek attia <tarek.m.attia@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks All,

I found a way to perform that,by enable Jaunty repo on the Karmic so I
can use the software packages that karmic doesn't suuport

Here are the steps :-

System->Administration->Software Sources.
Choose the Third-Party Software tab and hit Add, then enter:

deb http://us.archive.ubuntu.com/ubuntu/ jaunty multiverse

This will enable just the multiverse repo from Jaunty where
sun-java5-jdk resides. Allow it to reload the package list and then
your 'apt-get install' command should find the package..

On Mon, Dec 7, 2009 at 1:48 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> On Mon, 7 Dec 2009, tarek attia wrote:
>
>> Hi All,
>>
>> I got stuck in installing sun-java5 sdk on Karmic .
>>
>> # apt-get install sun-java5-jdk
>> Reading package lists... Done
>> Building dependency tree
>> Reading state information... Done
>> E: Couldn't find package sun-java5-jdk
>>
>> any idea?
>
>  wrong mailing list for that.
>
> rday
> --
>
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
>
>            Linux Consulting, Training and Kernel Pedantry.
>
> Web page:                                          http://crashcourse.ca
> Twitter:                                       http://twitter.com/rpjday
> ========================================================================
>
