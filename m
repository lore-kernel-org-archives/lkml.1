Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXETQPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXETQPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbXETQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:14:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:59513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbXETQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pS5f40EBxSIr0veaxZJWgNMIa6phku3KM2bZ6x5h3Z9+JDX39lxUBprRxj0BtaKV4tADW8Coz5A8YMYsBBCMW+YRqk6wREw1I7GAAqWFnt2BQRJW9eRRRWydVpvLQ4Am1jJvwvIm46NHJEhc3MW/otbpDWC3MAgGnEnRki9cCz0=
Message-ID: <2c0942db0705200914x3e418a49u2c0b80e478e23be@mail.gmail.com>
Date: Sun, 20 May 2007 09:14:49 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Al Viro" <viro@ftp.linux.org.uk>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Ken Chen" <kenchen@google.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <200705202009.39291.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <200705202009.39291.arvidjaar@mail.ru>
X-Google-Sender-Auth: a1f080ecd9b971dc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> On Sunday 20 May 2007, Ray Lee wrote:
> > The when part is what looks to make it racy. I'm guessing that we're
> > relying on udev to create those loop nodes. If so, I think any scheme
> > that creates more on demand would give transient mount errors while
> > it's waiting on udev to create more nodes.
>
> this seems to work with /dev/pts though. May be, by accident?

Or maybe the kernel puts the requesting process to sleep until the
udev userspace helper returns? I don't know.

I've run out of useful contributions to this thread, so I think I'll
shut up now :-).
