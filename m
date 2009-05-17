Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZEQHxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZEQHxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZEQHxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:53:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63475 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZEQHxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lELqKmXIoB9oGekAcDYvWOD+sQfXA5g+790pTo3Uj8H5iT/uBa1A1UtzbA2jM9h9PO
         JvgI8KwiIlXVCFveX2Zit6ikH6X4dPcoqV6YSY/xYacsxuNtwGQDLUgrCCiEW1JfVTBn
         0Dqxew1fzXFos4guUtz6MrabNGw5UwuK+RReA=
MIME-Version: 1.0
In-Reply-To: <pQ9WADCjgyE.A.QrG.PA0DKB@chimera>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
	 <pQ9WADCjgyE.A.QrG.PA0DKB@chimera>
Date: Sun, 17 May 2009 09:53:38 +0200
Message-ID: <8db1092f0905170053k5ccd8903k7b6d203dd349daeb@mail.gmail.com>
Subject: Re: [Bug #13172] Spontaneous reboots since 2.6.29-rc*
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13172
> Subject         : Spontaneous reboots since 2.6.29-rc*
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-04-17 17:03 (30 days old)
> References      : http://marc.info/?l=linux-kernel&m=123998788921733&w=4
>
>

I try:
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

from:
http://marc.info/?l=linux-kernel&m=124022460715035&w=4

Spontaneous reboots occur less often than in previous .config. From
last report it occur once or twice. I think, it's hardware/bios/mtrr
issue.

Because of this I think we should remove this regression from list,
until I find out, why it happen, or more people report this. What do
You think?

Regards


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
