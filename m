Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbZJPWq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbZJPWq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZJPWq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:46:28 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34027 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZJPWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=s68sjxaBjvwwQG+UieSsZj5NYYs4F6tz5NygU/EqR7ve1cQFUI/8OTggr/UpJFu5OG
         z+9ahywZutlewPBve3xP6eXUF4TKxV2BLe/qMWUK7R7iWDRQoh1KBFvExbEBjuo/NLnJ
         dw2EGc8AcsrDPPlGxnkAN8WeaUhxdWW3icKEw=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 23:46:31 +0100
Message-ID: <f1ac5a50910161546t6eeef710q6d40f22a61d15d1a@mail.gmail.com>
Subject: [kernel 2.6.31.4] backlight controls gone mad
From: =?ISO-8859-1?Q?N=E9lson_=ABVuDu=BB_Cunha?= <vudu.curse@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using ArchLinux (here's the "downstream" bug report:
http://bugs.archlinux.org/task/16698) and with the last update to
kernel 2.6.31.4 my backlight/brightness controls have gone mad.

My laptop's screen keeps blinking, slowly increasing or decreasing its
luminosity randomly. Sometimes it stays still for a couple of minutes
at any random brightness level, but it's very uncomfortable for the
eyes when it's blinking.
Here's a video of what's happening:
http://www.mediafire.com/download.php?z4mi4uzidjn

I've tried to use /proc/acpi/video/VGA/LCDD/brightness and
/sys/class/backlight/acpi_video0/brightness but with no luck, because
they make no changes and when I cat them I get wrong values.

I tried using xbacklight but it gives me "No outputs have backlight property".

With the previous (2.6.30.6) version I had no problems and after
getting this problem I installed Arch's "kernel26-lts" package
(2.6.27.37) and I'm having no issues with that kernel.

My laptop is an ASUS M51VA with an Intel C2D and an ATI HD 3650. I
tried fglrx, radeon and radeonhd and it made no difference.

If you need more details, please say so.

Best Regards.
