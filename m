Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYBJAii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYBJAii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 19:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYBJAi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 19:38:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbYBJAi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 19:38:29 -0500
Date: Sat, 9 Feb 2008 16:38:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid
 context at include/asm/uaccess_32.h:449
Message-ID: <20080209163812.704cf282@laptopd505.fenrus.org>
In-Reply-To: <20080209162643.fd3822f1.akpm@linux-foundation.org>
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com>
	<20080209162643.fd3822f1.akpm@linux-foundation.org>
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

On Sat, 9 Feb 2008 16:26:43 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Ugh, how did I let that one through?
> 
> Guys, how often mut it be said?  PLEASE always test all code with all
> kernel deubg options enabled.

maybe we should make a CONFIG_KERNEL_DEVELOPER option that SELECTs the
various options that really should be on.

If there is a chance of reasonable agreement on what those options are I'll cook
up a patch... (but I don't want to get bogged down in a 500 mail flamewar about
CONFIG_FOO_BAR being right for this or not...)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
