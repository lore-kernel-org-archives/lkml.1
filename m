Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZIUWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZIUWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZIUWrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:47:20 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:59105 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZIUWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:47:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 8759D3CA296
Message-ID: <4AB8027A.1040600@arcor.de>
Date: Tue, 22 Sep 2009 01:47:22 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: James Cloos <cloos@jhcloos.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de>	<20090920080728.73bfe2a1@infradead.org>	<4AB5ECD0.7010903@datenparkplatz.de>	<1253475521.9224.43.camel@marge.simson.net>	<4AB6C73C.1030004@gmail.com>	<1253507034.23414.90.camel@marge.simson.net>	<4AB72FDC.5090403@datenparkplatz.de>	<1253520364.25640.57.camel@marge.simson.net> <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
In-Reply-To: <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2009 10:47 PM, James Cloos wrote:
>[...]
> I had that kernel up for soemthing like five weeks, on a busy, low-ram
> laptop, w/o and long pauses or other noticeable pain.  For at least two
> years before that the best this laptop could manage before latency
> became horrific was a fortnight, and weekly reboots were desirable.
>
> Unfortunately, before I could send out a congratulatory note (I wanted
> to first confirm that the result remained) I pulled up and started see-
> ing even worse latency then ever.
>[...]
> A git pull on a clone of Linus' tree is a great way to trigger the
> problem.  As is using Gentoo's portage to install/upgrade anything.
> (Bad python; no alligator!¹)

Fortunately, this is completely (at least here) solved by putting those 
in make.conf:

PORTAGE_NICENESS=19
PORTAGE_IONICE_COMMAND="ionice -c 3 -p \${PID}"
