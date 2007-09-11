Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbXIKXeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbXIKXeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXIKXe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:34:29 -0400
Received: from 0006b10c8258.cranite.com ([63.81.170.2]:31964 "EHLO
	mailnode1.cranite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755018AbXIKXe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:34:29 -0400
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 19:34:29 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: irq load balancing 
Date: Tue, 11 Sep 2007 16:18:15 -0700
Message-ID: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: irq load balancing 
Thread-Index: Acf0ygfUJKRQcNi2QYOkKD81Pn+YTA==
From: "Venkat Subbiah" <venkats@cranite.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the load in my system is triggered by a single ethernet IRQ. Essentially the IRQ schedules a tasklet and most of the work is done in the taskelet which is scheduled in the IRQ. From what I read looks like the tasklet would be executed on the same CPU on which it was scheduled. So this means even in an SMP system it will be one processor which is overloaded.

So will using the user space IRQ loadbalancer really help? What I am doubtful about is that the user space load balance comes along and changes the affinity once in a while. But really what I need is every interrupt to go to a different CPU in a round robin fashion.

Looks like the APIC  can distribute IRQ's dynamically? Is this supported in the kernel and any config or proc interface to turn this on/off.


Thx,
Venkat

