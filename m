Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYAZUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYAZUqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAZUqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:46:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56481 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYAZUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:46:42 -0500
Date: Sat, 26 Jan 2008 12:45:14 -0800
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [BUILD FAILURE]2.6.24-git{1,2} kernel powerpc linkage failure
Message-ID: <20080126204514.GB30867@kroah.com>
References: <479B3453.3030105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479B3453.3030105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 06:53:31PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The 2.6.24-git2 kernel build fails on the power boxes with following build failure
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/powerpc/kernel/built-in.o: In function `fphalf':
> arch/powerpc/kernel/vector.S:(.toc+0x1428): undefined reference to `devices_subsys'
> make: *** [.tmp_vmlinux1] Error 1
> 
> This built-failure was seen in the mm broken-out-2007-11-06-02-32, I have tested 
> the patch posted to lkml at http://lkml.org/lkml/2007/11/6/208 fixes this issue.

And that patch is wrong, see my post on lkml about this yesterday.

Paul is working on a "correct" patch, and if I get some time this
afternoon, I'll do one too.

thanks,

greg k-h
