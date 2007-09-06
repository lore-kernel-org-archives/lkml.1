Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXIFPGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXIFPGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXIFPGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:06:30 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56528 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbXIFPG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:06:29 -0400
Date: Thu, 6 Sep 2007 11:06:16 -0400
To: Satyam Sharma <satyam@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
Message-ID: <20070906150616.GA28565@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 01:44:05PM +0530, Satyam Sharma wrote:
> /dev/kmem was just an example -- IMHO differentiating between kernel and
> userspace from a security p.o.v. is always tricky.

The things that come to mind are /dev/kmem and module-loading.  What
else is there?  And what is it that makes this inherently difficult?

> Like Trond said, there are very high number of ways in which
> privileged userspace can compromise a running kernel if it really
> wants to do that, root-is-God has always been *the* major problem with
> Unix :-)
> 
> The only _real_ way a kernel can lock itself completely against
> malicious userspace involves trusted tamperproof hardware,

The question of how to protect against someone with *physical* access
certainly is more difficult, but surely that's a separate problem.

--b.
