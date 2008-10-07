Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYJGXTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYJGXTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYJGXTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:19:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbYJGXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:19:24 -0400
Date: Tue, 07 Oct 2008 16:19:00 -0700 (PDT)
Message-Id: <20081007.161900.252724926.davem@davemloft.net>
To: jbarnes@virtuousgeek.org
Cc: jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
From: David Miller <davem@davemloft.net>
In-Reply-To: <200810021523.45884.jbarnes@virtuousgeek.org>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
	<20080930031927.22950.4692.stgit@jbrandeb-bw.jf.intel.com>
	<200810021523.45884.jbarnes@virtuousgeek.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 2 Oct 2008 15:23:43 -0700

> Ping DaveM.  Does this look ok?  What else would we need for you to remove 
> your range checking from sparc?

I can't do that until you add similar checking to the other
pci_mmap_page_range() call site in drivers/pci/proc.c
