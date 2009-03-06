Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZCFAOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZCFAOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCFAOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:14:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:35628 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZCFAOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:14:22 -0500
Date: Thu, 5 Mar 2009 16:14:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090305161451.0da40645@infradead.org>
In-Reply-To: <20090304121249.GA9855@linux.vnet.ibm.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 17:42:49 +0530
Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
> With the timers queued I measure the sleep state residency
> for a period of 10s.
> Next, I enable timer migration and measure the sleep state
> residency period.

is your table in seconds? Because realistically, at least on PC like
hardware, doing work to get sleep times over a 100 / 200 msecs or so
isn't going to save you any amount of measurable power anymore...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
