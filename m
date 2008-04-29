Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYD2Ws1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYD2Ws1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbYD2WsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:48:18 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:37525 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYD2WsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:48:18 -0400
Message-ID: <4817A3C1.1020908@freescale.com>
Date: Tue, 29 Apr 2008 17:40:01 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Mark Rustad <mrustad@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: Why use /bin/sh in kernel build system?
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org> <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com> <20080429214107.GA22735@martell.zuzino.mipt.ru> <20080429222456.GM8474@1wt.eu>
In-Reply-To: <20080429222456.GM8474@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> Hint: not every joe user may install bash into /bin... That's why we
> see some scripts begin with "/usr/bin/env bash" as there are less
> systems without env in /usr/bin than systems without bash in /bin (or
> at all).

I agree that #!/bin/bash is a bad idea.  I think the easiest, and maybe the
best, approach is to fix shell issue one-by-one.  The one I found was easily
fixed by Al Viro's here-document change.

-- 
Timur Tabi
Linux kernel developer at Freescale
