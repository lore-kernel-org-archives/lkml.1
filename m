Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXLLD7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXLLD7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 22:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXLLD7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 22:59:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbXLLD7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 22:59:15 -0500
Date: Tue, 11 Dec 2007 19:59:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc4-mm1 -- boot process hangs -- tty4 main process
 (2988) terminated with status 1
Message-Id: <20071211195908.28a8ec52.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712081829r3d3e0436qc9e55e3b5ca42f63@mail.gmail.com>
References: <a44ae5cd0712061956i1bd8f354rbfcffdbafad2e5d8@mail.gmail.com>
	<20071207021556.ce08dfa6.akpm@linux-foundation.org>
	<a44ae5cd0712081829r3d3e0436qc9e55e3b5ca42f63@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 21:29:18 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> > > Dec  6 21:24:28 erratic-orbits init: tty3 main process (2991)
> > > terminated with status 1
> >
> > Boggle.  We broke the vt driver?
> >
> > config, please...
> 
> I sent the .config.

I didn't receive it but I found a config from you in amother thread.

>  Is there nothing else to follow up on?  I have
> tried rebuilding about seven kernels, tweaking the options each time.
> All the kernels have failed to boot.   I am currently trying with a
> "defconfig" kernel.  Perhaps I will have better luck with it.

Your config instabricks my Vaio.  Fiddled with it a bit but failed to pick
the problem.  Fixing regressions in -mm isn't top priority at present I'm
afraid.  If the same bug is present in next -mm it'd be great if you could
bisect it down please.

