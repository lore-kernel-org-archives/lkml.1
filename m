Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXCODJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXCODJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 23:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXCODJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 23:09:31 -0400
Received: from pop-siberian.atl.sa.earthlink.net ([207.69.195.71]:61333 "EHLO
	pop-siberian.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbXCODJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 23:09:30 -0400
Subject: Re: [kvm-devel] [PATCH 01/15] KVM: Use a shared page for
	kernel/user communication when runing a vcpu
From: Hollis Blanchard <hollis@penguinppc.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1173926306.4611.6.camel@diesel>
References: <11736212072915-git-send-email-avi@qumranet.com>
	 <1173621207773-git-send-email-avi@qumranet.com>
	 <1173926306.4611.6.camel@diesel>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 22:09:23 -0500
Message-Id: <1173928163.4611.13.camel@diesel>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 21:38 -0500, Hollis Blanchard wrote:
> On Sun, 2007-03-11 at 15:53 +0200, Avi Kivity wrote:
> > Instead of passing a 'struct kvm_run' back and forth between the
> > kernel and userspace, allocate a page and allow the user to mmap() it.
> > This reduces needless copying and makes the interface expandable by
> > providing lots of free space.
> 
> Do you provide for another means of accessing guest memory from host
> userspace? For example, how do you attach a host debugger to the guest?
> 
> Xen uses an ioctl followed by mmap for this purpose, which is why I
> wonder about using mmap(/dev/kvm) for another purpose.

Never mind: I see now that you have separate device nodes for the VM vs
each vcpu.

-Hollis

