Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYIIMFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYIIMFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYIIMFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:05:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56741 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYIIMFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:05:32 -0400
Date: Tue, 9 Sep 2008 06:05:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 01/13] PCI Hotplug core: add 'name' param pci_hp_register interface
Message-ID: <20080909120514.GU2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100007.29542.27510.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100007.29542.27510.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:07AM -0600, Alex Chiang wrote:
> -extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
> +extern int pci_hp_register(struct hotplug_slot *,
> +			   struct pci_bus *,
> +			   int nr,
> +			   const char *name);

Not a huge fan of this style ... the usual style would be:

extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr,
				const char *name);

Otherwise Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
