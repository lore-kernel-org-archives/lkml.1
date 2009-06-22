Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZFVU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZFVU3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZFVU3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:29:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZFVU3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:29:34 -0400
Date: Mon, 22 Jun 2009 23:28:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
	notifier race conditions
Message-ID: <20090622202854.GJ15228@redhat.com>
References: <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FDAF1.6010700@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 03:26:41PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Mon, Jun 22, 2009 at 11:51:42AM -0700, Davide Libenzi wrote:
> >   
> >> A file* based kernel-to-kernel interface is rather wrong IMO.
> >>     
> >
> > But eventfd_ctx should work fine.
> >   
> 
> Yeah, and I guess we can always just say that qemu can't close the fd or
> something.  Seems hacky, but it might work if Davide insists we need his
> change.

Yes, I think that's fine.

-- 
MST
