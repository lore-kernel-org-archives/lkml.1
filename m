Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXIUTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXIUTi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbXIUTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:38:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbXIUTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:38:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=AHys+hynw/5CCOxYfdtt/CE1HYPyylmz8OerU6Dr3LqwmLfEqCT1fxVq2AsidCiv6
	hpVyY41dHr4ts7L36GfMA==
Date: Fri, 21 Sep 2007 12:38:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, andrea@suse.de, clameter@sgi.com
Subject: Re: + oom-move-prototypes-to-appropriate-header-file.patch added to
 -mm tree
In-Reply-To: <20070921170548.GA1857@martell.zuzino.mipt.ru>
Message-ID: <alpine.DEB.0.9999.0709211236130.29079@chino.kir.corp.google.com>
References: <200709210910.l8L9AttS028186@imap1.linux-foundation.org> <20070921170548.GA1857@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Alexey Dobriyan wrote:

> > Move the OOM killer's extern function prototypes to include/linux/oom.h and
> > include it where necessary.
> > 
> > Cc: Andrea Arcangeli <andrea@suse.de>
> > Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> NAK. Target in corresponding Kbuild is wrong. sched.h is overkill.
> Could we please also drop extern's while in protos?
> 

I'll prevent including sched.h in a follow-up patchset that I'll be 
posting soon (and you'll be Cc'd).  Which Kbuild target are you referring 
to?
