Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXCEIXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXCEIXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbXCEIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:23:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:53952 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbXCEIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:23:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Wl7nD86m0QG1pFnI9+yUqHMEAFbFKYJaUt7ddra8/OPz9YrtxXQnsQgT17f6cJnvgioPVA+wowMbK6VH48SZoLONEzWhwKDBN1ElJpvo7OPGxfUGNbKeuAzUY0/D34P81XTGa8v+68Cvmc0usIH4kIaHwvEC7Ixyeer8rGbUUUg=
Message-ID: <57354eff0703050023r419085f4y1f671feceed90f51@mail.gmail.com>
Date: Mon, 5 Mar 2007 09:23:13 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Mar, 21:50, Robin Getz <r...@blackfin.uclinux.org> wrote:
> On Sun 4 Mar 2007 14:46, Russell King pondered:
> >  The console command *only* sets the state for the kernel's use of one
> >  serial port.  It does not affect any other serial port, so tying
> >  random RTS behaviours into that command line option is absolutely
> >  silly.
> The real issue is that there is some legacy equipment, which gets confused if
> it sees glitches on RTS (which happens today, when serial core init asserts
> RTS, and then the the main application turns it off)...
>
> How do I set the set up the UART, so RTS is avaliable, but not enabled?

Yes, it is key issue. I think it is not silly to want to set up the
UART before RTS is enabled.
It is going not about some random RTS behaviour, but about the
question how to ask the
kernel just don't touch RTS signal. As I understand the current kernel
implementation
doesn't give a chance to do it.

I wrote about it also several days ago here:
http://groups.google.de/group/linux.kernel/browse_thread/thread/82e61dccd11c9e3f/b03971c074609c95?lnk=gst&q=Kebkal&rnum=1&hl=ru#b03971c074609c95
Maybe it would be more relevant to write it in this topic.

Thanks
-Oleksiy
