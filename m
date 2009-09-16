Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZIPHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZIPHBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZIPHBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:01:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbZIPHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:01:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wq8rcL5zc8ECTY1z2Ej+RICnLyVcVVD1r8QtukEtjWx4w8j9zeHKa0gPHbQxf/hMk
	E2KXbPBqlYDhQLxWZtzmA==
Date: Wed, 16 Sep 2009 00:01:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kurt Roeckx <kurt@roeckx.be>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
In-Reply-To: <20090916064708.GA25472@roeckx.be>
Message-ID: <alpine.DEB.1.00.0909152359131.13366@chino.kir.corp.google.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <200909080112.14997.rjw@sisk.pl> <20090908194653.GA3517@roeckx.be> <200909102259.15144.rjw@sisk.pl> <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com> <20090916064708.GA25472@roeckx.be>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Kurt Roeckx wrote:

> On Tue, Sep 15, 2009 at 04:45:37PM -0700, David Rientjes wrote:
> > On Thu, 10 Sep 2009, Rafael J. Wysocki wrote:
> > 
> > > > So I did a biset, and this is the result:
> > > > $ git bisect good
> > > > 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f is first bad commit
> > 
> > 0e64a0c has this cleanup, which isn't equivalent to the previous code:
> 
> Please look at the patch I attached to the bug report.  There is
> other code that is not equivalent.  It's in comment #17:
> http://bugzilla.kernel.org/show_bug.cgi?id=13780#c17
> 
> And the patch itself:
> http://bugzilla.kernel.org/attachment.cgi?id=23048
> 
> This patch fixes my problem.
> 

Ah, I hadn't noticed you attached a patch there that fixes the issue for 
you.  Is it en-route to Dave Jones so that it can make its way upstream?
