Return-Path: <linux-kernel-owner+w=401wt.eu-S965742AbXCGXPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbXCGXPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965741AbXCGXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:15:54 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:42691 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992716AbXCGXPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:15:34 -0500
Subject: Re: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data
	address
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Vivek Goyal <vgoyal@in.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
In-Reply-To: <20070307225006.GH5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com>
	 <20070307072008.GQ23412@in.ibm.com>  <20070307225006.GH5956@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 10:15:36 +1100
Message-Id: <1173309336.13442.2.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-03-07 at 23:50 +0100, Pavel Machek wrote:
> Hi!
> 
> > o virt_to_page() call should be used on kernel linear addresses and not
> >   on kernel text and data addresses. Swsusp code uses it on kernel data
> >   (statically allocated swsusp_header).
> > 
> > o Allocate swsusp_header dynamically so that virt_to_page() can be used
> >   safely.
> > 
> > o I am changing this because in next few patches, __pa() on x86_64 will
> >   no longer support kernel text and data addresses and hibernation breaks. 
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> 
> (I assume this was tested, too?)

Absolutely.

Nigel

