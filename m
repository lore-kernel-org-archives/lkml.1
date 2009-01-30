Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZA3OxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZA3OxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZA3OxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:53:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:38208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZA3OxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:53:16 -0500
Date: Fri, 30 Jan 2009 06:52:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v3)
Message-ID: <20090130065224.47729f41@infradead.org>
In-Reply-To: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
References: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 20:48:35 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch adds a function : driver_wait_probe_done,
> which waits on condition of probing done to replace
> polling for driver_probe_done in fs initialization.
> 
> There is no better way to avoid polling for
> driver_probe_done _and_ existence of the root device,
> so we does not replace the driver_probe_done with
> driver_wait_probe_done in such special case.
> 
> Removing polling in fs initialization may lead to
> a faster boot.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

ok this one will work fine ;)

Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>

thanks for fixing this up 
(it will clash with the patch that moves this to one place, but the
same cleanup can be done there)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
