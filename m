Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZDMLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZDMLz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZDMLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 07:55:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60956 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbZDMLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 07:55:17 -0400
Date: Mon, 13 Apr 2009 12:56:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Uhhuh. NMI received for unknown reason b0 on CPU 0.
Message-ID: <20090413125625.6926ef37@lxorguk.ukuu.org.uk>
In-Reply-To: <1239430584.10277.2.camel@localhost>
References: <1239430584.10277.2.camel@localhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 08:16:24 +0200
Soeren Sonnenburg <sonne@debian.org> wrote:

> Dear all,
> 
> I just got this error on a samsung nc 10 netbook running 2.6.29.1:
> 
> Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
> s3 kernel: Uhhuh. NMI received for unknown reason b0 on CPU 0.
> 
> Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
> s3 kernel: You have some hardware problem, likely on the PCI bus.
> 
> Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
> s3 kernel: Dazed and confused, but trying to continue
> 
> The thing operates as normal but leaves me (and the kernel!) confused?!
> 
> Should I be worried?

Possibly. NMI normally comes from things like dud memory.

I would try memtest86 for a few hours just to be sure, and also if you
can reproduce it load the edac base module and set it to poll for pci
errors.

It could also be arising from a software error triggering hardware so
knowing if its reproducable and how/when will be useful.
