Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXEWEUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXEWEUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXEWEUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:20:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43387 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbXEWEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:20:05 -0400
X-Sasl-enc: IZ1yoEQOokmi6x2bKX41aMnZuuO6oEHNObMrguyYjzOP 1179894003
Date: Wed, 23 May 2007 01:19:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070523041958.GA15952@khazad-dum.debian.net>
References: <20070519165738.GK11115@waste.org> <20070519204504.GA24704@khazad-dum.debian.net> <20070519223843.GN11115@waste.org> <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org> <20070521230349.GA645@khazad-dum.debian.net> <20070522224515.GW11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523014825.GX11115@waste.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Matt Mackall wrote:
> Whether the 'bug' is in the firmware or the kernel, it is the kernel
> that has regressed. Suspend worked fine for 2+ years before this.

That means something, but not that much.  The kernel could have been doing
broken things for two years in ACPI that happened to not trigger a bug in
someone's firmware, for example.  And when the kernel was fixed (to, e.g.,
do it right by the spec or unbreak other firmwares that did it by the spec)
and that triggered the bug.

We really need to find the cause of the regression to know.

> Breaking working systems, either software or hardware, is a bad idea.

We shouldn't do it for frivoulous reasons, of course.

> I shouldn't have to upgrade my BIOS to work with a new kernel any more
> than I should have to upgrade my browser.

We don't agree there, as you are not talking about a stable kernel series.

And btw, unless you hunt down someone that also has the bug and uses an
up-to-date BIOS (or something else to give an extra data point that discards
a possible firmware bug in your version of the BIOS), or bissect to pinpoint
what caused the regression, this thread will go nowhere.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
