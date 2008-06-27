Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYF0UTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYF0UTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYF0UTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:19:35 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45160 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYF0UTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:19:35 -0400
Message-ID: <48654974.6060200@freescale.com>
Date: Fri, 27 Jun 2008 15:11:32 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Nye Liu <nyet@mrv.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] POWERPC CPM: Minor cosmetic changes to udbg_putc
References: <20080627200100.GA16661@mrv.com>
In-Reply-To: <20080627200100.GA16661@mrv.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nye Liu wrote:
> udbg_putc is a *function pointer* that is initialized during
> udbg_init_cpm. It might not be initialized properly when called from
> udbg_putc_cpm(), so (recursively) call udbg_putc_cpm() directly.

ACK

> Printing an "X" on initialization is ugly. How about a "\n" instead?

D'oh, that was a debugging leftover that I missed when cleaning things 
up.  Just remove it.

-Scott
