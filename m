Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbZBLWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbZBLWU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZBLWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:20:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:24283 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbZBLWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hMvz1h4n19Dfm/UdmMC8Vc76C+AULao3CPpa1HJNo+UzmRuwF4jCszYjrAu86ve7fB
         iefKv+Ab04kkAs0fowkTzDVpRvZ/tm3dd6wIkk73QHBWdozsit/bi2jxB2jX2x0p3ZhL
         LAhixDzMSKuBSecfGRaPuYirhHBYL4arVeBi0=
MIME-Version: 1.0
In-Reply-To: <20090130204955.GC1253@ucw.cz>
References: <20090128113809.GA29424@elf.ucw.cz>
	 <20090128194723.GA1394@flint.arm.linux.org.uk>
	 <20090130204955.GC1253@ucw.cz>
Date: Thu, 12 Feb 2009 23:20:12 +0100
X-Google-Sender-Auth: 87f5c467064eb0de
Message-ID: <dc2200690902121420n77d86c96r5a215a69f5671265@mail.gmail.com>
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
From: =?windows-1252?Q?Cyril_Hrubi=9A?= <metan@ucw.cz>
To: Pavel Machek <pavel@suse.cz>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       thommycheck@gmail.com, milan@ucw.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The display problems seems to be cpufreq related. It changes type of
bad effects when varying cpu speed from slow and random line redraw to
flashing big white random patterns. And I've seen similar behaviour
with voipac pxa module where framebuffer with cpu set to 416Mhz moves
accidentally some pixels to the right under cpu load. Moreover several
speed changes leads to "hda: lost interrupt" on spitz.

-- 
watashi |v|3+@n
Cyril Hrubis
watashi.metan@gmail.com
http://atrey.karlin.mff.cuni.cz/~metan/
