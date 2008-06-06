Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbYFFEQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbYFFEQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYFFEQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:16:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:59621 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYFFEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:16:35 -0400
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
In-Reply-To: <20080605151140.GA12991@ldl.fc.hp.com>
References: <20080604200829.GC379@ldl.fc.hp.com>
	 <20080604201606.GE379@ldl.fc.hp.com>
	 <20080604224838.6b556a51.akpm@linux-foundation.org>
	 <48478247.30809@jp.fujitsu.com>
	 <20080604233348.eb46d8de.akpm@linux-foundation.org>
	 <20080605151140.GA12991@ldl.fc.hp.com>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 14:07:41 +1000
Message-Id: <1212725261.12464.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW. In the meantime, your current patch set seems fine to go.

I'll add code to actually do the renumbering of the slot separately,
along with some other cleanup & rework of the pseries PCI hotplug
I started doing.

Ben.


