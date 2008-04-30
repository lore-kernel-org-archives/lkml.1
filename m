Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbYD3LsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbYD3LsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYD3LsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:48:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33062 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYD3LsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:48:05 -0400
Date: Wed, 30 Apr 2008 13:48:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Willy Tarreau <w@1wt.eu>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Mark Rustad <mrustad@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Timur Tabi <timur@freescale.com>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why use /bin/sh in kernel build system?
In-Reply-To: <20080429222456.GM8474@1wt.eu>
Message-ID: <alpine.LNX.1.10.0804301347530.5623@fbirervta.pbzchgretzou.qr>
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org> <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com>
 <20080429214107.GA22735@martell.zuzino.mipt.ru> <20080429222456.GM8474@1wt.eu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-30 00:24, Willy Tarreau wrote:
>
>Hint: not every joe user may install bash into /bin... That's why we
>see some scripts begin with "/usr/bin/env bash" as there are less
>systems without env in /usr/bin than systems without bash in /bin (or
>at all).

Too bad #!bash does not search $PATH.
