Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZJWQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZJWQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZJWQZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:25:57 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:36587 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbZJWQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:25:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAM9w4UpGGN1W/2dsb2JhbACBUNgchD8E
Date: Fri, 23 Oct 2009 12:26:00 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Relicensing immediate values to Dual LGPL v2.1/GPL v2, headers to
	Dual BSD/GPL
Message-ID: <20091023162600.GA4495@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:23:11 up 66 days,  3:12,  2 users,  load average: 0.12, 0.17,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

In the LTTng tree, I would like to re-license
arch/sparc/kernel/immediate.c from GPL to:

 * Dual LGPL v2.1/GPL v2 license.

And re-license arch/sparc/include/asm/immediate.h to:

  * Dual BSD/GPL v2 license.

The goal is to allow sharing code between the kernel tracer and UST
(User-Space Tracer) project, which is a LGPL v2.1 library. Immediate
values headers might need to be included by proprietary or BSD
applications, hence the dual BSD/GPL v2 license for this header.

Do I have your OK to do this ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
