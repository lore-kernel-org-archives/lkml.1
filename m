Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZD3Web@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZD3Web (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZD3WeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:34:22 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55306 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZD3WeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:34:21 -0400
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Marc Pignat <Marc.Pignat@hevs.ch>,
       Roger Quadros <ext-roger.quadros@nokia.com>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0904302056270.5012@wotan.suse.de>
References: <49F9C1AD020000BF00029086@mailgw2.hevs.ch>
	 <alpine.LRH.2.00.0904301556310.2050@twin.jikos.cz>
	 <1241103783.3389.35.camel@localhost.localdomain>
	 <alpine.LNX.2.00.0904302056270.5012@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 15:34:14 -0700
Message-Id: <1241130854.3197.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > > My bluetooth keyboard is not working any more in rc4, but was 
> > > > working in rc3. Here is the dmesg output, triggered by the first key 
> > > > press on the keyboard, fortunately, this is 100% reproductible (once 
> > > > per boot).
> > > Does reverting f3784d834c7 fix the problem?
> > we have seen a similar report where reverting f3784d834c7 didn't fix it. 
> > And I don't see anything wrong with that patch. Did something important 
> > got changed in the work queue code that I am missing?
> 
> Calling flush() from work->func() is not safe. That's what the WARN_ON() 
> in flush_cpu_workqueue() is there for, right?

I don't know since this got changed in 2.6.30-rc1. I do have this kernel
running and I have seen the WARN_ON() only once. However I have never
seen a NULL pointer because of this patch.

Regards

Marcel


