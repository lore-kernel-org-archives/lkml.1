Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772Ab0ABP4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0ABP4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725Ab0ABP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:56:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37839 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0ABP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:56:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HgMXHb8IUxVz93JcohRSfs37Za8Ai82YRopCqPdFmHZnHUO2+oUycjGdV0HGnI5LPK
         JeoTnBpDqRZgoWQ0uK+dUcB3H2edbw91yLDAFo1cAnFcWdi4LhKyAzgvw2UgjfGybGAM
         wTKbQH9VGX/5b8AkV6botuESXejD7bJy/yWJo=
MIME-Version: 1.0
In-Reply-To: <1262446824.3058.11.camel@palomino.walls.org>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	 <4B3F5264.7000008@gmail.com> <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
	 <6f52f5b81001020713j5435cfadr1143806a9026adc2@mail.gmail.com>
	 <6f52f5b81001020715i79d2ea1j33443fa50fbb593c@mail.gmail.com>
	 <1262446824.3058.11.camel@palomino.walls.org>
Date: Sat, 2 Jan 2010 16:56:15 +0100
Message-ID: <6f52f5b81001020756i73fbb137if1af8ac8b306f6ba@mail.gmail.com>
Subject: Re: [suspend/resume] Re: userspace notification from module
From: Daniel Borkmann <danborkmann@googlemail.com>
To: Andy Walls <awalls@radix.net>
Cc: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

2010/1/2 Andy Walls <awalls@radix.net>:
> Why not:
>
> a. write a module that implements a device node that supports poll(),
> and
>
> b. have a user space process select() on the fd for read or exception
> notification
>
> ?

This is, of course, another possible solution that is more "cleaner"
than the one with the signals.
Then, your userspace program would have another thread polling for the
device node. Question is which timeout would be appropriate to be "CPU
friendly" and to keep notification latency short?

Cheers,
Daniel
