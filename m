Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbXIPSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbXIPSZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXIPSYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:24:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:65417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbXIPSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tmjvIqwOjh9MiOPVkj1vnPpCBl7e8Mv/sWUOL6VqYtx5OzSaaRQfOyJa0OEWpguxIQEwf4vG78Jp4qPgmASZIgSzwuTvBl200jIu7jSASSOdjtfVyk2L1BXHmdp4y1RStsV+CERaggwbDyIY+8wHM8IlYjj1YEmF8NcOnou8VcI=
From: Matej Laitl <strohel@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH v3] menuconfig: distinguish between selected-by-another options and comments
Date: Sun, 16 Sep 2007 20:24:47 +0200
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709152004.11930.strohel@gmail.com> <200709161944.31780.strohel@gmail.com> <Pine.LNX.4.64.0709161955340.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0709161955340.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709162024.48124.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 of September 2007 19:59:56 Roman Zippel wrote:
> Right now I prefer the previous version.

The v2 was maybe more intuitive, but had at least one flaw, where it claimed
the option was selected by another, while it was in fact only made
unchangeable by 'bool "Enable block layer" if EMBEDDED', defaulting to y.

> This maximum value is overridden  
> by the minimum value, so I wouldn't like it to be exported like this.

Where exactly does this happen? There are cases when maximum < minimum, for
example when you <M> THINKPAD_ACPI, then <N> BACKLIGHT_LCD_SUPPORT. After that,
BACKLIGHT_CLASS_DEVICE has minimum of 1 (selected by THINKPAD_ACPI) and maximum
0 (depends on BACKLIGHT_LCD_SUPPORT, which is n)

The function names are maybe suboptimal, I agree.

> I would really like to see an example, where the new changes make a 
> difference.

Try saying <M> to MAC80211, wireless extensions were -*- with v2, now are (*) with v3.
Also the symbols ( ), { } are changed and more well-defined in v3 IMHO.

Regards,
         Matěj
