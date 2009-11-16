Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZKPJYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZKPJYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZKPJYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:24:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33337 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbZKPJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:24:41 -0500
Date: Mon, 16 Nov 2009 09:26:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steve Meisner <smeisner@charter.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Parallel Driver(s) Broke in 2.6.31
Message-ID: <20091116092636.2b12e3c5@lxorguk.ukuu.org.uk>
In-Reply-To: <200911152154.47510.smeisner@charter.net>
References: <200911152154.47510.smeisner@charter.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009 21:54:47 -0500
Steve Meisner <smeisner@charter.net> wrote:

> I posted to the Mandriva forum with no luck yet.  I recently upgraded to 
> Mandriva 2010.0 and in doing so lost ability to use my parallel printer.  
> After many hours of debugging effort and finding nothing in logs or 
> hardware/driver error messages, I went on a hunch that it could be related to 
> the kernel.  So I rolled back to the 2009.1 kernel 2.6.29 and printing 
> returned.  I don't know how to proceed with determining the root cause as I 
> cannot find any error in the logs or differences in hardware detection and 
> module loading.  I don't even know the hierarchy of the modules involved 
> (parport, parport, pc, lp, and ppdev).   Should I start diffing those modules 
> and see if I get lucky applying hacking 101 techniques?  Please CC me 
> (smeisner@charter.net) if you have any suggestions (except for buying a new 
> printer).

Start by looking at the boot messages from each ("dmesg" as a command
will show you them after boot).

