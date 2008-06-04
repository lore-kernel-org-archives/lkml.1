Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbYFDX60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbYFDX60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYFDX6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:58:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57559 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599AbYFDX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:58:17 -0400
Date: Wed, 4 Jun 2008 16:55:26 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       lenb@kernel.org, pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Export kobject_rename for pci_hotplug_core
Message-ID: <20080604235526.GA3428@kroah.com>
References: <20080604200829.GC379@ldl.fc.hp.com> <20080604201606.GE379@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604201606.GE379@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 02:16:06PM -0600, Alex Chiang wrote:
> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> Export kobject_rename() to fix the following link error.  This happens when
> pci_hotplug_core driver is compiled as a kernel module.
> 
> ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Acked-by: Alex Chiang <achiang@hp.com>
> Cc: Greg KH <greg@kroah.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

