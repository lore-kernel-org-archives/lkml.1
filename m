Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYFJV67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYFJV67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJV6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:58:49 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:49082 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbYFJV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:58:48 -0400
Date: Tue, 10 Jun 2008 23:58:46 +0200
Message-Id: <311993399@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: keith@karsites.net
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18ZOq9YDb8n8tKzVaZB5UfJ12U99q75EKI/pnpvAv6ceLJ4W
 eGSfPIncYVEHnxZLJ3svM22UWGdt0wrj/W8145yrtop9uXzIEo=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hi all. I have a problem with trying to boot from a Fedora 9 
>installation CD-R. It works on another machine, so the disk 
>is OK. I guess if anyone knows the answer then it will be 
>found here on the kernel developers list.
>
>When trying to boot from a CD-R installation disk, on my 
>Advent 6415 laptop I get the following:
>
>Welcome to Fedora 9! [the installer splash screen]
>
>  I then click on either:
>
>  Install or upgrade an existing system
>  [or]
>  Install or upgrade an existing system (text mode)
>
>  [both give me the same following error]
>
> Loading vmlinuz........................................... 
>..............
>
>  Loading initrd.img........................................ 
>.................
>  ...............ready.
>  Probing EDD (edd=off to disable)... ok
>  vmlinuz: attempted DOS system call
>  boot:
>
>  If I hit return now, the machine goes back to the 'Welcome 
>to Fedora 9!' splash screen.
>
>I have edited the kernel parameters at the spalsh screen and 
>tried:
>
>edd=skipmbr edd=off
>
>All that does is not display the line:
>  Probing EDD (edd=off to disable)... ok

as you can see "ok" , then this is no edd problem
it would have been an edd problem if you could only see
the message before "ok".

>The installation still hangs at the boot: prompt.
>
>Has anyone come across the behaviour before please?
>

no, but i`m sure that this is not related to edd.

not sure if this is fedora specific, but it seems so - see for example:

http://blogs.gnome.org/diegoe/2008/04/10/vesamenuc32-attempted-dos-system-call/

maybe some issue with the vesa bios probe for getting video mode information or switching to appropriate mode.

cc`ing hpa - maybe he as a clue.....

>Is there any way I can get my laptop to boot from this 
>media, maybe by passing some undocumented kernel parameters?

see that link. try booting with "linux" or "linux0".

i think it`s good to report to the fedora people - maybe the have added stuff which doesn`t work reliable...

>Kind Regards,
>Keith Roberts

regards
roland

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

