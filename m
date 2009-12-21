Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZLUT63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZLUT63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZLUT62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:58:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:44553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLUT60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=taZozokfgvbV+uE8FZOFx5OeA1U1LDsd55mGJc6r5BXaPHcNmXx54OvNgmg0TmypnV
         E+FOYes/t41A9WnA7RfNdBt1VYo/i8LpjsckU3CfQFy/sIEAAmTgiHO1PVKYPlYmPEgK
         zuc7FUr0VZjKM2H6JBEwBWF4Rv+pGFCUrBojE=
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B2F22EF.6040500@crca.org.au>
References: <200912210140.19713.rjw@sisk.pl>  <4B2F22EF.6040500@crca.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 21:58:19 +0200
Message-ID: <1261425499.4328.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 18:25 +1100, Nigel Cunningham wrote: 
> Hi.
> 
> Rafael J. Wysocki wrote:
> > I'm not sure what the next step should be at this point.  To me, the picture is
> > quite clear now, but perhaps we ought to run more tests on some other machines
> > or something.  Please let me know what you think.
> 
> Looks great. If you do decide you want other machines tested, I'll
> happily try the machines around here:
> 
> - Dell M1530
> - Omnibook XE3-GF.
> - Via LN10000 based Mythtv Box
> - Desktop machine - Some Intel-based mobo I've forgotten the name of.
> 
> I've been quietly following the thread, but have lost track of what
> iteration of the patch you're on, so if you'd give me a pointer to it,
> I'd be grateful.
> 
> By the way, I haven't forgotten about sending some real patches for
> swsusp (ie more than just cleanups). I'm just busy with other things and
> also thinking carefully about what order to do things in.

I vote for ability to save all ram to the disk.
After several days of testing I managed to make my system do s2disk
really reliable (~300 cycles tested), but suspending when memory is
tight still fails sometimes.

I didn't yet use your tuxonice system  though.

Best regards,
Maxim Levisky







