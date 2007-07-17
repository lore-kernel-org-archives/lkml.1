Return-Path: <linux-kernel-owner+w=401wt.eu-S1765328AbXGQOnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765328AbXGQOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXGQOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:43:12 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:56960 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXGQOnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:43:11 -0400
Message-ID: <469CD54A.4040003@mandic.com.br>
Date: Tue, 17 Jul 2007 11:42:18 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
In-Reply-To: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sasa Ostrouska escreveu:
> I want to ask one question about a custom resolution in the console.
> I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> ugly as I get a border of about 2-3cm on one the sides of the screen.
> So is there a way that I set the 1280x800 resolution at boot time ?

Use vga=866 to set 1280x800 in boot time.
In Documentation/fb/vesafb.txt is commented only 1280x1024, but in same 
man page is commented that you can read /Documentation/svga.txt and in 
this document you can find this:

** Short intro for the impatient: Just use vga=ask for the first time,
** enter `scan' on the video mode prompt, pick the mode you want to use,
** remember its mode ID (the four-digit hexadecimal number) and then
** set the vga parameter to this number (converted to decimal first).

Regards,
Renato S. Yamane
