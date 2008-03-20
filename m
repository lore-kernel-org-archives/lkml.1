Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbYCTCuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbYCTCuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCTCuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:50:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:50123 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYCTCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sq5RQTnym5bWA9BgfXuAwkQ7rbfObLJW20YcOO2DvRQnCKbaZDwXxm3aFI/py56AHMLmTgFn5ggsYzbKDYkHlWT8Cs6RKQDmctBI/fTorQxyeJFAbglgegTho5PzE1NSug7V5Qym1QFGw0c85D8nzdoIqmBPcBmjXykxmsmxk8Y=
Message-ID: <a8e1da0803191950s1a656fffq98fbc180069814d9@mail.gmail.com>
Date: Thu, 20 Mar 2008 10:50:22 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
Cc: "Pavel Machek" <pavel@ucw.cz>, marcel@holtmann.org, maxk@qualcomm.com,
       "kernel list" <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <47E1A112.4060208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080319082115.GA14543@elf.ucw.cz> <47E19BA1.8010905@gmail.com>
	 <20080319230624.GJ1811@elf.ucw.cz> <47E1A112.4060208@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 7:26 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Removed the bluez-devel@.
>
>
>  On 03/20/2008 12:06 AM, Pavel Machek wrote:
>  > On Thu 2008-03-20 00:02:57, Jiri Slaby wrote:
>  >> On 03/19/2008 09:21 AM, Pavel Machek wrote:
>  >>> ...just leave ppp-over-cellphone-over-bluetooth running, and do
>  >>> s2ram...
>  >>>
>  >>> Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
>  >>> BIOS-provided physical RAM map:
>  >> Pavel, does the "still" from $SUBJ mean, that 2.6.24 is affected too (if
>  >> this is the same what I hit)?
>  >
>  > Hey, I did not do careful analysis. I believe it is the same problem
>  > that affects 2.6.24, too, yes. But I actually believe it is much older
>  > than that...
>
>  If yes, then I got the crash by using hidp over l2cap with non-hid device
>  (session->input). I'm not sure if it was connected at all and even if hidd was
>  running (I tested moving with mouse by cellphone with switching on and off the
>  daemon, since it needed some little changes).
>
>  If you, hci fellows, are interested I might send more detailed description of
>  the crash tomorrow.

add linux-bluetooth@vger.kernel.org in cc

>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
