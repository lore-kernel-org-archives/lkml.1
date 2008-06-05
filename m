Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYFEGVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYFEGVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYFEGVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:21:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:34599 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYFEGVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bietSaP6453EdwsgEJjAQEcdfJc15LwnPAsLyqZCJLIaU+bSoBStGxAh9pWYYFptfl
         3pXpiBtWsAtFNjMEIJdkISdT+NoG7w8oMeMocU9FVBqrYOUFiuZqPn3WoTv6F7LV3use
         3Jca9cbjSAJLS4ALCzt3hQpGIbtViRALelFOM=
Message-ID: <1e15d0630806042321l4fca3c17m3660ba3da517dbc3@mail.gmail.com>
Date: Wed, 4 Jun 2008 23:21:45 -0700
From: "=?ISO-8859-1?Q?St=E9phane_Charette?=" <stephanecharette@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux kernel debugging
In-Reply-To: <e1e39aa7-b9f4-4ad4-9874-87c430d4f53f@i18g2000prn.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e1e39aa7-b9f4-4ad4-9874-87c430d4f53f@i18g2000prn.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in the 2.2.13 kernel days, I would hook up 2 computers via serial
ports and could use ddd/gdb to walk through the kernel on the 2nd
computer.

My old notes tells me I would enabled "Kernel Hacking -> Kernel
support for GDB" when running "make menuconfig", and then add "gdb
gdbttyS=1 gdbbaud=115200" when booting the 2nd computer.

Is this still the way to do it?

I'd like to play around with this again after many years of not having
looked at the kernel internals.  One of the things I found tonight
while searching for info on the web is this:

http://kgdb.linsyssoft.com

Is this what it has evolved into, or is this something else?  It looks
like a commercial product, which is why I was reluctant to dig further
into it.  I guess what I'm asking is:  What is the most common method
people use to walk a debugger through the linux kernel?

Thanks,

Stéphane Charette
