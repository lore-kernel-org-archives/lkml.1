Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYKCW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYKCW6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYKCW54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:57:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbYKCW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:57:55 -0500
Date: Mon, 3 Nov 2008 14:57:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: edac: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-Id: <20081103145733.3b1701d1.akpm@linux-foundation.org>
In-Reply-To: <1225327145.5970.30.camel@nga.site>
References: <1225327145.5970.30.camel@nga.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 01:39:05 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> Subject: edac: struct device - replace bus_id with dev_name(), dev_set_name()

um,

ERROR: space required after that ',' (ctx:VxV)
#40: FILE: drivers/edac/edac_mc.c:404:
+               "%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
                                                     ^

ERROR: space prohibited after that open parenthesis '('
#40: FILE: drivers/edac/edac_mc.c:404:
+               "%s (%s) %s %s already assigned %d\n",dev_name( p->dev),


where did this crap come from?  It looks like some automated thing
placed a space at the wrong end of the string?

If so, are we about to send hundreds of such mistakes into the tree?

(checkpatch!  Is good!)
