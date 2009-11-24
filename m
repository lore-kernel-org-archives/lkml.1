Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbZKXKb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbZKXKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbZKXKb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:31:58 -0500
Received: from mga10.intel.com ([192.55.52.92]:44059 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932612AbZKXKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:31:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,275,1257148800"; 
   d="scan'208";a="516844799"
Date: Tue, 24 Nov 2009 10:14:02 +0000
From: Alan Cox <alan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer: Add a mod_timer_msec() API function
Message-ID: <20091124101402.0214c919@linux.intel.com>
In-Reply-To: <alpine.LFD.2.00.0911231728200.24119@localhost.localdomain>
References: <20091122154111.197e1a8a@infradead.org>
	<20091123082648.GB13186@elte.hu>
	<20091123065108.1fd78779@infradead.org>
	<alpine.LFD.2.00.0911231728200.24119@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If there are a few timers which really need large and precise timeouts
> its easy enough to switch them over to hrtimers.
> 
> Thoughts ?

Seems good to me - also fits with the long term need to push the core
timer handling into the hypervisor when running lots of VMs as it will
make it easy to keep all the VM timers lined up with each other
