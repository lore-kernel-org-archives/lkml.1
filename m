Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZH0JNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZH0JNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZH0JNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:13:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:48267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZH0JNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:13:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,285,1249282800"; 
   d="scan'208";a="545216571"
Date: Thu, 27 Aug 2009 10:08:09 +0100
From: Alan Cox <alan@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Amit Shah <amit.shah@redhat.com>, qemu-devel@nongnu.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, miltonm@bga.com,
       linuxppc-dev@ozlabs.org, brueckner@linux.vnet.ibm.com
Subject: Re: Extending virtio_console to support multiple ports
Message-ID: <20090827100809.5f0aa0a7@linux.intel.com>
In-Reply-To: <1251346023.20467.21.camel@pasglop>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com>
	<20090826112718.GA11117@amit-x200.redhat.com>
	<20090826154552.GA31910@amit-x200.redhat.com>
	<1251346023.20467.21.camel@pasglop>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - Then, are we certain that there's no case where the tty layer will
> call us with some lock held or in an atomic context ? To be honest,
> I've totally lost track of the locking rules in tty land lately so it
> might well be ok, but something to verify.

Some of the less well behaved line disciplines do this and always have
done.

Alan
 

