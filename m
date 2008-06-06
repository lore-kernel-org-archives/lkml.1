Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbYFFXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbYFFXcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYFFXcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:32:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:37231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbYFFXci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:32:38 -0400
Subject: Re: [PATCH] kobject: Export kobject_rename for pci_hotplug_core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       jbarnes@virtuousgeek.org, Matthew Wilcox <matthew@wil.cx>,
       kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
       pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080606045138.GA28538@ldl.fc.hp.com>
References: <20080604200829.GC379@ldl.fc.hp.com>
	 <20080604201606.GE379@ldl.fc.hp.com>
	 <20080604224838.6b556a51.akpm@linux-foundation.org>
	 <48478247.30809@jp.fujitsu.com>
	 <20080604233348.eb46d8de.akpm@linux-foundation.org>
	 <20080605151140.GA12991@ldl.fc.hp.com> <1212725261.12464.4.camel@pasglop>
	 <20080606045138.GA28538@ldl.fc.hp.com>
Content-Type: text/plain
Date: Sat, 07 Jun 2008 09:20:00 +1000
Message-Id: <1212794400.12464.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 22:51 -0600, Alex Chiang wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> > BTW. In the meantime, your current patch set seems fine to go.
> 
> That sounds suspiciously like an Acked-by: to me... ;)

Yup, the only thing is .. I would like to do a few more tests to make
sure we didn't break an obscure setup but I suppose we can always
do fixup patches if necessary. So yes,

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> > I'll add code to actually do the renumbering of the slot
> > separately, along with some other cleanup & rework of the
> > pseries PCI hotplug I started doing.
> 
> Great, thanks!
> 

