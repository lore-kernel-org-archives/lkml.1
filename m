Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZL2OLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZL2OLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZL2OLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:11:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZL2OLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:11:11 -0500
Date: Tue, 29 Dec 2009 16:07:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kvm@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: vhost net on 10ge with x2apic
Message-ID: <20091229140743.GC10234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got hold of some 10Ge cards and did some light benchmarking of kvm networking
with and without vhost net accelerator, while enabling x2apic emulation.
I've put a summary of results here:
http://www.linux-kvm.org/page/VhostNet#Performance

Main conclusions: vhost net improves latency (a lot) and bandwidth/cpu
utilization (less).  With x2apic and a recent guest, virtio userspace
has decent bandwidth but high latency and cpu utilization.  vhost net
bandwidth can get very close to native bandwidth (95%).
We still have work to do tuning virtio guest drivers.

-- 
MST
