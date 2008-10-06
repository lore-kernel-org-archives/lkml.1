Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYJFJFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYJFJFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJFJE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:04:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39219 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYJFJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:04:58 -0400
Date: Mon, 6 Oct 2008 03:04:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v4 01/15] PCI Hotplug core: add 'name' param pci_hp_register interface
Message-ID: <20081006090441.GC25780@parisc-linux.org>
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231732.9989.11667.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003231732.9989.11667.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 05:17:32PM -0600, Alex Chiang wrote:
> Update pci_hp_register() to take a const char *name parameter.
> 
> The motivation for this is to clean up the individual hotplug
> drivers so that each one does not have to manage its own name.
> The PCI core should be the place where we manage the name.
> 
> We update the interface and all callsites first, in a
> "no functional change" manner, and clean up the drivers later.
> 
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 

Simple, clean, obvious.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
