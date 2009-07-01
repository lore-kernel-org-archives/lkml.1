Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbZGABT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbZGABT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbZGAAh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:37:29 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:33274 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761954AbZGAAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=CjRgMme691O7m7C7I7ncXb60QMhzWDs7QxpdZ+zJjsWTVmw0tDrnP56Uq0Rzywcv0X
         Vbduri8cz1Q1ANiX8qze+owHZ/IYn9S2hbiKmxUinsGwOslDAZ7bQ4QZ4W3T8a27ORhM
         FyQskDiP6kbvOtyEenVr1A3jNv6UDqftJxE7w=
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: yanhua <yanh@lemote.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <4A4AAB93.6040306@lemote.com>
References: <1246372868.19049.17.camel@falcon> <4A4AAB93.6040306@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 01 Jul 2009 08:37:16 +0800
Message-Id: <1246408636.12459.3.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 08:19 +0800, yanhua wrote:
> Wu Zhangjin 写道:
> > Hi,
> >
> > I just updated my git repository to the master branch of the latest
> > linux-mips git repository, and tested the STD/Hibernation support on
> > fuloong2e and yeeloong2f, it failed:
> >
> > when using the no_console_suspend kernel command line to debug, it
> > stopped on:
> >
> > PM: Shringking memory... done (1000 pages freed)
> > PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> > PM: Creating hibernation image:
> > PM: Need to copy 5053 pages
> > PM: Hibernation image created (4195 pages copied)
> >
> > and then, the number indicator light of keyboard works well, but can not
> > type anything. 
> >
> >   
> Are there any other information about it? such as: it just freezes
> there, or IDE irq lost messages after some time?
>
> Is it duplicable every time?

Yes, it is reproductive, I'm tracing it!

Thanks!

