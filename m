Return-Path: <linux-kernel-owner+w=401wt.eu-S1765722AbYDVS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765722AbYDVS6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765469AbYDVS4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:56:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57513 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765467AbYDVS4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:56:30 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object
	creation with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, orenl@cs.columbia.edu,
       nick@nick-andrew.net
In-Reply-To: <20080422193612.GA15835@martell.zuzino.mipt.ru>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 11:56:20 -0700
Message-Id: <1208890580.17117.14.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 23:36 +0400, Alexey Dobriyan wrote:
> On Fri, Apr 18, 2008 at 07:44:59AM +0200, Nadia.Derbey@bull.net wrote:
> >    . echo "LONG XX" > /proc/self/task/<my_tid>/next_id
> >      next object to be created will have an id set to XX
> >    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/task/<my_tid>/next_id
> >      next object to be created will have its ids set to XX0, ... X<n-1>
> >      This is particularly useful for processes that may have several ids if
> >      they belong to nested namespaces.
> 
> Can we answer the following questions before merging this patch:
> 
> a) should mainline kernel have checkpoint/restart feature at all
> b) if yes, should it be done from kernel- or userspace?
> 
> Until agreement will be "yes/from userspace" such patches don't make
> sense in mainline.

What do you mean by "from kernel" or "from userspace"?  Userspace has to
be involved somewhere, right?  It at least need to open() the checkpoint
file and pass it into the kernel.  		

-- Dave

