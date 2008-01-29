Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYA1QQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYA1QQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYA1QQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:16:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:45267 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYA1QQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:x-mailer:x-operating-system:user-agent;
        b=Xif8yInuoZeXQf6gYGSTmA0bd9UpjDIpRu1FOfI2AV/YBlQOY3RoTGkNmrryKiXSmU3rm21eVKsH66zoMQvEia5RzIoICXKllvTy/J5NxOo6NlhPxHGxfXK6/LvEEnCFMo/fPp3C++LUodo1VbzyVZpzfUhATiUo8GxU3Z9cRxk=
Date: Tue, 29 Jan 2008 08:21:40 +0800
From: Zhenyu Wang <zhen78@gmail.com>
To: mark gross <mgross@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [agp-mm][PATCH 1/4][intel_iommu] explicit export current graphics dmar status
Message-ID: <20080129002140.GA11932@localdomain>
References: <20071218050809.GA12564@zhen-devel.sh.intel.com> <20071219052030.GA24238@zhen-devel.sh.intel.com> <20071219052608.GB24238@zhen-devel.sh.intel.com> <20080104015338.GA17253@zhen-devel.sh.intel.com> <20080108204420.GA9491@linux.intel.com> <20080125030255.GB19129@zhen-devel.sh.intel.com> <20080125180820.GA16868@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125180820.GA16868@linux.intel.com>
X-Mailer: mutt
X-Operating-System: Linux 2.6.24-rc6 unknown
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.25 10:08:20 -0800, mark gross wrote:
> > This is used for our graphics driver module to know if we have to
> > do dma remapping in iommu case, both in kernel config and kernel
> > boot time param config. 
> 
> ok. How soon do you need this export?
> 

As graphics part of these patches depend on this one, it should go
first, or along with agpgart patches, that should first be in Airlie's
agp-mm queue.

> send me your current patch and eta for the graphics module patches so I
> can better coordinate with you.

You can find my current patches against agp-mm tree (so equally against
current -mm kernel) here, http://people.freedesktop.org/~zhen/, fixed
with some warnings from checkpatch.

