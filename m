Return-Path: <linux-kernel-owner+w=401wt.eu-S1765835AbXGTXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765835AbXGTXkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbXGTXjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:39:53 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:36042 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128AbXGTXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:39:53 -0400
Date: Fri, 20 Jul 2007 19:39:49 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@redhat.com>,
       dgoeddel@trustedcs.com, Frank Mayer <mayerf@tresys.com>,
       Karl MacMillan <kmacmillan@tresys.com>, paul.moore@hp.com,
       Chad Sellers <csellers@tresys.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH][SELinux] Let us not leak memory in SELinux :
 security_netlbl_cache_add()
In-Reply-To: <200707210012.45185.jesper.juhl@gmail.com>
Message-ID: <Line.LNX.4.64.0707201938500.12490@d.namei>
References: <200707210012.45185.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Jesper Juhl wrote:

> Hi,
> 
> Leaking memory is a bad idea, so let's not do it, in 
> security/selinux/ss/services.c::security_netlbl_cache_add().
> 
> Note: The Coverity checker gets credit for spotting this one.
> Note: Patch has only been compile tested.

Thanks!

Verified and applied to:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus





- James
-- 
James Morris
<jmorris@namei.org>
