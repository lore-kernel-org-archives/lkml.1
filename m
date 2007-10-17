Return-Path: <linux-kernel-owner+w=401wt.eu-S935733AbXJQQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733AbXJQQgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbXJQQgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:36:01 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49909 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760288AbXJQQgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:36:00 -0400
Date: Wed, 17 Oct 2007 18:35:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
In-Reply-To: <20071011181137.GA3868@ucw.cz>
Message-ID: <Pine.LNX.4.64.0710171820570.28622@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
 <20071011181137.GA3868@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 18:11, Pavel Machek wrote:
>
>> It is already possible to deactivate the vc bell on a per-tty basis,
>> by using echo -en "\e[11;0]", but this is reset on reset(1).
>> 
>> This adds a sysfs parameter to globally control the vc bell, as well
>> as sysfs parameters for default pitch and duration.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
>There are more parameters that should be set during reset... like
>cursor size and color, palette, .... What about /sys/.../string_to_interpret
>_on_reset ?

On reset(1), cursor size, palette, and bell parameters _do_ get reset
to the defaults. Some defaults may already be changed by the user,
like palette or default_utf8.

Bell configuration is currently not one of them so, should a program
decide to reset the tty, or should it happen that your output is
garbled (forcing you to do reset), some settings change back to
"unwanted defaults".
