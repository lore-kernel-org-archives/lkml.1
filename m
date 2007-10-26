Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbXJZDK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbXJZDK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXJZDKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:10:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47130 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbXJZDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:10:50 -0400
Date: Thu, 25 Oct 2007 20:07:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Permit silencing of __deprecated warnings.
Message-ID: <20071025200701.614388fe@laptopd505.fenrus.org>
In-Reply-To: <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
	<41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 04:06:13 -0400 (EDT)
Jeff Garzik <jeff@garzik.org> wrote:

> The __deprecated marker is quite useful in highlighting the remnants
> of old APIs that want removing.
> 
> However, it is quite normal for one or more years to pass, before the
> (usually ancient, bitrotten) code in question is either updated or
> deleted.
> 
> Thus, like __must_check, add a Kconfig option that permits the
> silencing of this compiler warning.
> 
> This change mimics the ifdef-ery and Kconfig defaults of MUST_CHECK as
> closely as possible.
> 

it would be nice if we could have this always-on for external modules,
so that people who're developing new modules realize from the start
that they're using API's they shouldn't, no matter what config option
they (or their distro) picked...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
