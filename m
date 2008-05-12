Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYELPzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYELPzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYELPzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:55:44 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:52633 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYELPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OT9waPGJvtWjhjfnCwF6ZFmoRsHpmQEAssnmBSew0xkVzpk6/C6tJuVym4k7byKex0ArcSoaTZP1QQddzSQh5EgwcWb7fnd/92fhi54Jex6Y9kZYR27+biMC3zrd63dHEBsQCtpw21RG2eSGj4H7EwfM7znFAPYGYrNEI7zmym4=
Message-ID: <8dacd7b30805120855q406f566ma187142719bf5bd4@mail.gmail.com>
Date: Mon, 12 May 2008 17:55:42 +0200
From: "Jan Niklas Hasse" <jhasse@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: libata - DMA problems ICH7 rev 02
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <481BD00E.7050302@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.6VoLd5Q2gfHHZZfYneNkQcGjXKk@ifi.uio.no>
	 <fa.kzdMLVO0bqLAbXEBqWrKyBntgxc@ifi.uio.no>
	 <fa.h4D6h2c4Yz08K7snVTVtewbsziM@ifi.uio.no> <481BD00E.7050302@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 4:38 AM, Robert Hancock <hancockr@shaw.ca> wrote:
>  This is expected. IOWait just means the system is blocked waiting for IO
> and has nothing else to do. It does not mean that DMA is not working.
>
>  [...]
>
>  Looks like you are using DMA:
>
>  ata1.00: configured for UDMA/100
>  ata1.01: configured for UDMA/33
>

Hm.. strange. But the problem is that my system slows down
nevertheless (sometimes the mouse cursor stops moving for a short time
or all my programs don't react). How can i find out what is causing
the problem?

Here I was creating a DVD with dvdauthor which was copying some big
video files. It was nearly impossible to use a web browser, although
CPU load seems only to be 12.7%.

top - 20:33:08 up  4:58,  2 users,  load average: 2.94, 2.81, 2.49
Tasks: 134 total,   2 running, 132 sleeping,   0 stopped,   0 zombie
Cpu(s):  5.0%us,  7.7%sy,  0.0%ni, 16.2%id, 70.1%wa,  0.3%hi,  0.8%si,  0.0%st
Mem:   1019568k total,   996316k used,    23252k free,     1148k buffers
Swap:  2916344k total,    83892k used,  2832452k free,   325284k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2609 root      15  -5     0    0    0 S    6  0.0   6:41.67 kcryptd
 6344 root      20   0  543m 129m  10m S    3 13.0   6:33.63 Xorg
27062 jhasse    20   0 23164 6424 1176 D    3  0.6   0:11.98 dvdauthor
 6891 jhasse    20   0  208m  18m 8956 S    2  1.9   3:13.41 transmission
27173 jhasse    20   0  263m  24m  12m S    2  2.4   0:00.66 gnome-terminal
  195 root      20   0     0    0    0 S    1  0.0   0:00.14 pdflush

Another example: When I'm burning a disc and at the end, when my drive
finishes the disc (and makes those noises) the computer freezes untill
the CD is finished and ejected (about 3 seconds).

I hope it's the right place to ask here at the mailing list and thanks
for your help so far.
