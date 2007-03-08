Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXCHFEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXCHFEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXCHFEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:04:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52946 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbXCHFEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:04:39 -0500
Date: Thu, 8 Mar 2007 10:34:07 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data address
Message-ID: <20070308050407.GG6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307072008.GQ23412@in.ibm.com> <20070307225006.GH5956@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307225006.GH5956@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:50:06PM +0100, Pavel Machek wrote:
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
> 									Pavel

Yes. I have tested this and it works fine.

Thanks
Vivek
