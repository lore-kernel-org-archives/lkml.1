Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZA0VCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZA0VCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZA0VCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:02:09 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47685 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZA0VCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:02:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AssFABgFf0lMQWt2/2dsb2JhbACBbsk8hUw
Date: Tue, 27 Jan 2009 16:02:03 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng 0.87 improved page fault tracing
Message-ID: <20090127210203.GA13478@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:54:52 up 26 days, 20:53,  4 users,  load average: 1.61, 1.22,
	0.99
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just combined the 4 page fault handler events that were in the tracing
hot path of LTTng into 2 :

kernel page_fault_entry
kernel page_fault_exit

They take as parameter the combination of what was available in the
trap_entry/exit events and handle_mm_fault entry/exit events. This
should lessen the performance impact of the tracer when it's active.
I did the related modifications in LTTV 0.12.8.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
