Return-Path: <linux-kernel-owner+w=401wt.eu-S1765239AbXJZQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765239AbXJZQmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764243AbXJZQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:38:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:58856 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbXJZQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:38:08 -0400
Message-ID: <472217F7.6060501@ru.mvista.com>
Date: Fri, 26 Oct 2007 20:38:15 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes
 breakage
References: <20071026155648.GB4321@flint.arm.linux.org.uk> <47221164.10200@ru.mvista.com> <alpine.LFD.0.999.0710260929290.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710260929290.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Linus Torvalds wrote:

>>   We can just convert cariables declared as 'struct hpt_info' to const too -- 
>>they are read-only templates.

> Generally "__devinitdata" is better than "const", since it means that the 
> data may be thrown away.

    Agreed.

> So if you drop one over the other,

    No, just add 'const' to already __devinitdata data to make gcc happy again.

> it's generally the "const" that should be dropped ;/

    Well, this may break when/if we need to add __devinitdata that is actually 
r/w -- not likely with this driver but still...

> 		Linus

WBR, Sergei
