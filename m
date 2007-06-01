Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbXFAXLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbXFAXLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXFAXLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:11:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbXFAXLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:11:16 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Thierry Merle <thierry.merle@free.fr>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <465F3361.106@free.fr>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <1180378677.21547.189.camel@localhost>
	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>
	 <465BBAFB.30906@free.fr> <1180448712.21547.314.camel@localhost>
	 <465C7920.2080203@free.fr> <1180467116.9509.73.camel@localhost>
	 <465F3361.106@free.fr>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 20:10:01 -0300
Message-Id: <1180739401.3904.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > This seems to be an interesting approach.
> >
> >   
> Interesting but impossible to do for ioctl calls.
> When the application does a ioctl(fd_of_mnt_video0,VIDIOC_G_FMT,&arg) 
> for example, there is no way for the userspace helper to catch this ioctl.
> The application could only open/read from the userspace helper's file 
> /mnt/video0.
> ioctl would still have to be done on the kernel device driver.
> I thought also about a /proc interface for decompression algorithms (a 
> helper would listen on a /proc file and write on another /proc file) but 
> /proc is not designed for that kind of thing.
> A separate library seems to be the simplest solution.

There are some ways for this to work. For example, you may create a
helper device for the daemon driver to bind, even requiring it to have
root permission.

-- 
Cheers,
Mauro

