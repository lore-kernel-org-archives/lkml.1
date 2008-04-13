Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYDMTT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYDMTT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYDMTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:19:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbYDMTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:19:15 -0400
Date: Sun, 13 Apr 2008 12:18:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection (was: Re: 2.6.25-rc8: FTP transfer
 errors)
Message-Id: <20080413121831.d89dd424.akpm@linux-foundation.org>
In-Reply-To: <20080413184730.GD8474@1wt.eu>
References: <47FEADCB.7070104@rtr.ca>
	<22880.1207943922@turing-police.cc.vt.edu>
	<47FFE5DA.8000709@imap.cc>
	<200804132040.12138.rjw@sisk.pl>
	<20080413184730.GD8474@1wt.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 20:47:30 +0200 Willy Tarreau <w@1wt.eu> wrote:

>  One other thing which might get confusing/frustrating on the
> user side is that currently, Linux is the *only* product which requires
> the bug reporter to find the fault change

That's because many (probably most) Linux bugs are dependent upon the
hardware which they run on, and developers cannot reproduce the failure on
their hardware.  Other software products don't have that problem.


That being said..  four or five years ago, developers would often work
closely with the reporter working out why the reporter's failure was
occurring.  Several days of back-and-forth.

We dont' do that as much nowadays - there's a tendency to

a) throw the problem back at the reporter, often asking them to bisect. 
   If the reporter is running a distro kernel (eg: Fedora) then that's
   quite hard, and often isn't a think they have knowledge to do.  So
   they'll just disappear.  Or

b) just ignore the report altogether.


