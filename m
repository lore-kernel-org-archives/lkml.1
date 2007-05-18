Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXERObc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXERObc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXERObY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:31:24 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:44879 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbXERObX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:31:23 -0400
X-Greylist: delayed 2525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 10:31:23 EDT
Message-ID: <464DAE73.7000302@cs.columbia.edu>
Date: Fri, 18 May 2007 09:47:31 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted
 filesystems
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com>
In-Reply-To: <20070518111042.GC4869@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:

> 
> Not really. This is called during copyup of a file residing in a lower
> layer. And that is done only for regular files.

That is broken.

You should be able to change the permissions on a device node on a layer 
that is RO.

so it would copy it up (1. mknod, 2. copy attributes) and then the 
appropriate attribute notification change would be called.
