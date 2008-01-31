Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYAaOiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYAaOiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYAaOh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:37:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58438 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbYAaOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:37:58 -0500
Date: Thu, 31 Jan 2008 06:36:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: EFI memory mapping changes according to
 changes to ioremap and c_p_a
Message-ID: <20080131063651.678c6652@laptopd505.fenrus.org>
In-Reply-To: <1201764968.12950.26.camel@caritas-dev.intel.com>
References: <1201764968.12950.26.camel@caritas-dev.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 15:36:08 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> The patch fixes EFI runtime memory mapping code according to the
> changes to ioremap() and change_page_attr().

this is way overkill. really.

Just call set_memory_x() after your ioremap call, and call set_memory_nx() before the iounmap.
THere is no need to hack up ioremap for any of this stuff. At all.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
