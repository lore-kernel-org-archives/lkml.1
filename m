Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZIQNLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZIQNLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbZIQNLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:11:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51946 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754221AbZIQNLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:11:31 -0400
Date: Thu, 17 Sep 2009 14:13:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
  maintenance disaster
Message-ID: <20090917141303.428fe73c@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  * A static dev is faster.
> 
> A static /dev is unreliable and unpredictable, and can not be used in
> any not very limited and controlled environment. It's pure theory for

Moblin appears to be the fastest boot and doesn't use it. I fact Arjan
seems pretty anti

> Eric, ever wondered why all the people working in hotplug area,
> maintaining todays systems, and even the ones who wrote udev, want
> this? And only people who have never written any code in hotplug land

"All". Thats a bit of a fiction.


But this is the wrong argument anyway

The question is
- Is it technically correct
- Does it properly interact with the rest of the kernel and upcoming stuff

So I'd like to see the fs folks sign off on it - which they've noticably
not done yet.

Whether you want devfs2 (ie devtmpfs) or static dev or udev is a
configuration and user dependant question no different to what fs do you
prefer. Whether it actually works and doesn't screw stuff up is a rather
more important technical question that needs proper review from the fs
list, which is notably lacking right now, except in the negative.
