Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXJNNzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXJNNzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXJNNyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:54:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54525 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXJNNyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:54:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ciprian Dorin Craciun" <ciprian.craciun@gmail.com>
Subject: Re: Linux v2.6.23.1 suspend/resume problem
Date: Sun, 14 Oct 2007 16:10:39 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1192347847.289067.216320@q5g2000prf.googlegroups.com> <8e04b5820710140058o650634av4b0426c463b62cb0@mail.gmail.com>
In-Reply-To: <8e04b5820710140058o650634av4b0426c463b62cb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141610.39850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 October 2007 09:58, Ciprian Dorin Craciun wrote:
>     Hello all!
> 
>     I have just compiled v2.6.23.1 kernel yesterday and started using
> it. But it seems there are some issues with the suspend/resume... Whet
> my laptop resumes it takes a lot of time, about half a minute to
> resume. I watched the timings in the dmesg output and it seems it
> hands either at the souncard setup or the SATA controller. (I'm not an
> expert, I just guessed that based on dmesg, so I might be wrong...)
> 
>     I must add that I haven't encountered this problem with any of the
> previous stable kernels. The last one I have used was v2.6.22.9. And
> the difference of the two configs is not essential.

Well, so this is a post 2.6.22 regression.

Can you please file a bug at http://bugzilla.kernel.org (in the power
management category, hibernation/suspend) and attach all of the relevant
information to it?

Thanks,
Rafael
