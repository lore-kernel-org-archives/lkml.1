Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXI3TmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXI3TmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXI3Tlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:41:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXI3Tlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:41:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: Fwd: [Suspend2-devel] [patch] 2.2.10.3 build fixes
Date: Sun, 30 Sep 2007 21:56:45 +0200
User-Agent: KMail/1.9.5
Cc: "Linux-pm mailing list" <uclinux-v850@lsi.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709302144.08688.nigel@nigel.suspend2.net>
In-Reply-To: <200709302144.08688.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302156.45894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 30 September 2007 13:44, Nigel Cunningham wrote:
> Hi Rafael et al.
> 
> This looks like it will be vanilla material, maybe 2.6.23 material?

Well, I wouldn't like to export freezer.h .  Why exactly would that be
necessary?

Greetings,
Rafael


> ----------  Forwarded Message  ----------
> 
> Subject: [Suspend2-devel] [patch] 2.2.10.3 build fixes
> Date: Sunday 30 September 2007
> From: "Roman Dubtsov" (dubtsov gmail com)
> 
> Hi,
> 
> I have recently run into build issue with 2.6.22 and tuxonice
> 2.2.10.3. When building custom kernel with make-kpkg the process
> failed with the message saying: "fs.h requires linux/freezer.h, which
> does not exist in exported headers". Here's quick-n-dirty patch which
> fixes this. Hope it is usefull.
> 
> --- 2.6.22-toi/include/linux/Kbuild.orig  2007-09-30 01:21:30.000000000 +0700
> +++ 2.6.22-toi/include/linux/Kbuild       2007-09-29 23:52:52.000000000 +0700
> @@ -202,6 +202,7 @@ unifdef-y += filter.h
>  unifdef-y += flat.h
>  unifdef-y += futex.h
>  unifdef-y += fs.h
> +unifdef-y += freezer.h
>  unifdef-y += gameport.h
>  unifdef-y += generic_serial.h
>  unifdef-y += genhd.h
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
