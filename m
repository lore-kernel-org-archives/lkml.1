Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYKLXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYKLXH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKLXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:07:20 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50183 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbYKLXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:07:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAIfqGklMQWxa/2dsb2JhbACBds99g1c
Date: Wed, 12 Nov 2008 18:07:16 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: LTTng 0.53 implements new generic tracing clock
Message-ID: <20081112230716.GA6696@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:02:50 up 161 days,  3:43,  7 users,  load average: 6.15, 3.01,
	1.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've implemented a new timer-based generic tracing clock in LTTng 0.53.
It's only for architectures lacking proper TSC suppport. It is less
intrusive than the previous implementation and does not depend directly
on the jiffy variable. It should work better on NO_HZ systems. Only when
tracing is active, a timer will fire every jiffy.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
