Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXLIPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXLIPLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXLIPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:11:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:23832 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLIPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZVwdX/B6l8dowvxUjL4X6e9F3WmsqFpr9FUHonpgLggjUcmeP/17NG0kXtnMZ70yTBsMSF8epVr3MLQqF/rs3H5SF+7NsmBSWvb97diR3xtfjxi3W6/MRIZ8cK8zF1+KU/lnBeVXuBcucagecyAbzPnxMJ1bYVaLjD8CyD3m8K0=
Message-ID: <475C0585.3090304@gmail.com>
Date: Mon, 10 Dec 2007 00:11:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl> <20071208013631.3147986a.akpm@linux-foundation.org> <475B90C7.4070505@gmail.com> <200712091520.04740.rjw@sisk.pl>
In-Reply-To: <200712091520.04740.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>> If any machines _are_ breaking then this could cause real problems
>>> and I'd prefer that we either go for a whitelist or arrange to
>>> detect the condition and fall back to non-acpi ata.
>> The pending patchset should make ATA ACPI quite resistant to failures.
> 
> Are you going to push it for 2.6.24?

Yeah, I'm hoping so.  Maybe command filtering should wait till 2.6.25
but the rest, yeap.

-- 
tejun
