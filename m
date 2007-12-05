Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXLEMRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXLEMRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXLEMQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:16:57 -0500
Received: from namei.org ([69.55.235.186]:33145 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbXLEMQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:16:56 -0500
Date: Wed, 5 Dec 2007 23:15:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Alan Cox <alan@redhat.com>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] VM/Security: add security hook to do_brk
In-Reply-To: <20071204164358.GA18050@devserv.devel.redhat.com>
Message-ID: <Xine.LNX.4.64.0712052315150.25177@us.intercode.com.au>
References: <1196784415.2912.164.camel@localhost.localdomain>
 <20071204164358.GA18050@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Alan Cox wrote:

> On Tue, Dec 04, 2007 at 11:06:55AM -0500, Eric Paris wrote:
> > Given a specifically crafted binary do_brk() can be used to get low
> > pages available in userspace virtually memory and can thus be used to
> > circumvent the mmap_min_addr low memory protection.  Add security checks
> > in do_brk().
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> ACK

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

-- 
James Morris
<jmorris@namei.org>
