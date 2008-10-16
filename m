Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYJPOiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYJPOiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYJPOhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:37:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:51958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYJPOhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:37:51 -0400
Date: Thu, 16 Oct 2008 07:37:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] timers: Timer migration
Message-ID: <20081016073749.4f944a19@infradead.org>
In-Reply-To: <20081016114239.GA7641@linux.vnet.ibm.com>
References: <20081016114239.GA7641@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 17:12:39 +0530
> 
> 
> Here's a brief introduction as to why we need timer migration.
> 

as I've said before, for reducing power consumption I don't buy into
needing this concept....

If you have high frequency timers, you've lost no matter what (and we
fixed almost all of them in the ecosystem); if you don't have those
then this patch doesn't really add anything.
(and the range-hrtimers fixes the intermediate state)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
