Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYGSQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYGSQIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGSQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:08:09 -0400
Received: from homer.mvista.com ([63.81.120.158]:18366 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYGSQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:08:07 -0400
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080719083532.21c9a43e@infradead.org>
References: <20080718151524.5ef9e29b@infradead.org>
	 <20080718151608.46dc17c0@infradead.org>
	 <1216430540.3978.137.camel@localhost.localdomain>
	 <20080718204406.7426e8fe@infradead.org>
	 <1216440697.3978.142.camel@localhost.localdomain>
	 <20080718222014.34754e7b@infradead.org>
	 <1216481066.3978.159.camel@localhost.localdomain>
	 <20080719083532.21c9a43e@infradead.org>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 09:08:05 -0700
Message-Id: <1216483685.3978.161.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 08:35 -0700, Arjan van de Ven wrote:

> > Ok .. I'm not trying to rush you .. With that said, the increased
> > number of threads seems like a natural direction to take.. I would
> > assume the returns would diminish depending on the number of threads
> > per the hardware.. For instance , your addition of one thread might
> > even harm the boot time on some single core embedded systems ..
> 
> well it still improves the cases where msleep() happens... even on
> single core. (fwiw the test  machine I reported numbers from is single
> core, albeit with hyperthreading)
> 

How did you measure the boot time? I didn't notice any infrastructure
for that in the patches..

Daniel

