Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYDMJJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYDMJJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYDMJI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:08:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbYDMJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:08:57 -0400
Date: Sun, 13 Apr 2008 10:04:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413100402.0ff381a3@core>
In-Reply-To: <20080413033344.GA27494@hash.localnet>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Honestly, I'm not sure if this FS is mainline material or not.  If it is, 

It looks mainline to me. It is far more relevant than most of the other
file systems we support and it doesn't mess up core code at all. It's a
loadable kernel module so the impact is basically nil, as well as being
useful to other folk writing file systems.

> Most of it was done by members of the ReplayTV community; I just used
> their documentation.  I'll see if I can get in touch with one of them to 
> see how they came up with that.  I only figured out a few things, for 
> which I'd use the Karma as a black box for copying/deleting files etc. 
> and then poke at the resulting disk image with a hex editor.

If you used their documentation and didn't do the reverse engineering or
read any ReplayTV code there shouldn't be any problems. The big danger is
if you reverse engineer their code and you write new code you may copy
their implementation even accidentally (or be held to have done so).

Alan
