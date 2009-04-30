Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbZD3Pde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbZD3Pde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763234AbZD3Pcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:32:51 -0400
Received: from mailgw2.hevs.ch ([153.109.6.17]:25741 "EHLO mailgw2.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762541AbZD3Pcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:32:50 -0400
Message-Id: <49F9E0BA020000BF00029098@mailgw2.hevs.ch>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 30 Apr 2009 17:32:42 +0200
From: "Marc Pignat" <Marc.Pignat@hevs.ch>
To: <marcel@holtmann.org>, <jkosina@suse.cz>
Cc: <ext-roger.quadros@nokia.com>, <linux-bluetooth@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Marcel Holtmann <marcel@holtmann.org> 04/30/09 5:03 PM >>>
>Hi Jiri,

>> > My bluetooth keyboard is not working any more in rc4, but was working in 
>> > rc3.
>> > Here is the dmesg output, triggered by the first key press on the 
>> > keyboard, fortunately, this is 100% reproductible (once per boot).
>> 
>> Does reverting f3784d834c7 fix the problem?

>we have seen a similar report where reverting f3784d834c7 didn't fix it.
It seems to fix it for me...

>And I don't see anything wrong with that patch. Did something important
>got changed in the work queue code that I am missing?

Is this a good idea to flush the current queue? (add_con and del_con call flush_workqueue(bluetooth),
but add_con and del_con are run by this queue).

Best regards

Marc
