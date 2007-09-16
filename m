Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbXIPQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbXIPQQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXIPQQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:16:36 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47782 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbXIPQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:16:36 -0400
Date: Sun, 16 Sep 2007 18:16:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, marc.smith@esmail.mcc.edu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-ID: <20070916181619.2787f4a6@twins>
In-Reply-To: <EF4D78B7-DCE2-49E7-B31E-AB9A9B7F7609@mac.com>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
	<C9A68AAE-0B37-4BB5-A9E6-66C186566940@cam.ac.uk>
	<1189855141.21778.307.camel@twins>
	<EF4D78B7-DCE2-49E7-B31E-AB9A9B7F7609@mac.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 03:22:11 -0400 Kyle Moffett <mrmacman_g4@mac.com>
wrote:

> On Sep 15, 2007, at 07:19:01, Peter Zijlstra wrote:
> > On Sat, 2007-09-15 at 11:50 +0100, Anton Altaparmakov wrote:
> >> I haven't word wrapped it at all.  The lines appear as whole lines  
> >> in Apple Mail (my email client).  It must be your email client  
> >> that is wrapping them...
> >
> > Oddly, this line is still long in Andrew's reply but wrapped in  
> > yours.  Must be some odd mailer interaction.
> 
> Actually Apple Mail.app sends format=flowed wrapped to 73  
> characters.  So a wrapped line has a single space character right  
> before each 'wrapping' newline.  If your mail client supports  
> format=flowed viewing and sends without format=flowed (like AKPM's  
> mailer appears to), then it will properly unwrap the lines and resend  
> without the wrapping.  Mailers which *DONT* support format=flowed  
> will see the wrapped version.  Normally this is what you want but  
> it's a PITA for patches and logfiles.
> 
> I believe with Mail.app if you attach a .txt file it will be  
> unmangled and sent as "Content-Type: text/plain" and "Content- 
> Disposition: inline", so most email-clients will display it as part  
> of the message.

Ah, thanks for the hint. I've switched mailer to claws-mail-3.0.0 and
hacked the thing a bit so its useful. One of the things I added was a
menu entry for respect_flowed_format. So I can now flip between flowed
and non-flowed with a key.
