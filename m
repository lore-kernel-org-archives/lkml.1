Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXKTV5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXKTV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXKTV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:57:28 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56076 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbXKTV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:57:27 -0500
Message-ID: <474355BE.8030409@student.ltu.se>
Date: Tue, 20 Nov 2007 22:46:38 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alejandro Martinez Ruiz <alex@flawedcode.org>
Subject: Re: [patch 02/13] dio: ARRAY_SIZE() cleanup
References: <20071118101336.330321764@mail.of.borg> <20071118101446.793269838@mail.of.borg>
In-Reply-To: <20071118101446.793269838@mail.of.borg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> -#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
> +#define NUMNAMES ARRAY_SIZE(names)

Why not replace NUMNAMES?

/Richard Knutsson


