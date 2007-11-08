Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXKHSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXKHSrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760285AbXKHSrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:47:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44138 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109AbXKHSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:47:16 -0500
Date: Thu, 8 Nov 2007 10:28:44 -0800
From: Greg KH <greg@kroah.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: Compilation warnings of kernel 2.6.24-rc2
Message-ID: <20071108182844.GA420@kroah.com>
References: <200711080829.38340.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711080829.38340.uwe.bugla@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 08:29:38AM +0100, Uwe Bugla wrote:
> Hello everybody,
> 
> this is a list of compilation warnings produced during compilation of kernel 
> 2.6.24-rc2. gcc is version is 4.2.2-3. Architecture is i386.
> Distro is Debian Lenny / Sid.
> 
> 4. drivers/pci/search.c: In function ‘pci_find_slot’:
> drivers/pci/search.c:135: warning: ‘pci_find_device’ is deprecated (declared 
> at include/linux/pci.h:492)
> drivers/pci/search.c: At top level:
> drivers/pci/search.c:478: warning: ‘pci_find_device’ is deprecated (declared 
> at drivers/pci/search.c:283)
> drivers/pci/search.c:478: warning: ‘pci_find_device’ is deprecated (declared 
> at drivers/pci/search.c:283)
> drivers/pci/search.c:479: warning: ‘pci_find_slot’ is deprecated (declared at 
> drivers/pci/search.c:132)
> drivers/pci/search.c:479: warning: ‘pci_find_slot’ is deprecated (declared at 
> drivers/pci/search.c:132)

These warnings can not go away until these functions can go away
entirely.  Hopefully that will happen soon, but there are still drivers
using these old functions :(

thanks,

greg k-h
