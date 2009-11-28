Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZK1U3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZK1U3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 15:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZK1U3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 15:29:21 -0500
Received: from khc.piap.pl ([195.187.100.11]:35399 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZK1U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 15:29:20 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<4B116954.5050706@s5r6.in-berlin.de>
	<9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	<m3ws1awhk8.fsf@intrepid.localdomain>
	<9e4733910911281214o614fd912wbbe5dcc50108aeea@mail.gmail.com>
Date: Sat, 28 Nov 2009 21:29:23 +0100
In-Reply-To: <9e4733910911281214o614fd912wbbe5dcc50108aeea@mail.gmail.com>
	(Jon Smirl's message of "Sat, 28 Nov 2009 15:14:32 -0500")
Message-ID: <m3bpimwfz0.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl <jonsmirl@gmail.com> writes:

> Endianess comes into play when send/receiving multibyte integers on
> platforms with different endianess.

It's the case when you're sending this data to a machine with
a different endianness. For example, in a network or to another CPU in
e.g. add-on card.
Ioctls are not affected by this, since both ends are the same.

Obviously you can be affected if you try to access data as integers in
one point and as arrays of bytes in the other, but it has nothing to do
with ioctls.
-- 
Krzysztof Halasa
