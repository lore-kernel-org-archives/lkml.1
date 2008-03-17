Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYCQJ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYCQJ3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYCQJ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:29:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbYCQJ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:29:41 -0400
Date: Mon, 17 Mar 2008 04:29:39 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [18/18] Implement hugepagesz= option for x86-64
Message-Id: <20080317042939.051e76ff.pj@sgi.com>
In-Reply-To: <20080317015832.2E3DF1B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	<20080317015832.2E3DF1B41E0@basil.firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
+	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
+	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
+			On x86 this option can be specified multiple times
+			interleaved with hugepages= to reserve huge pages
+			of different sizes. Valid pages sizes on x86-64
+			are 2M (when the CPU supports "pse") and 1G (when the
+			CPU supports the "pdpe1gb" cpuinfo flag)
+			Note that 1GB pages can only be allocated at boot time
+			using hugepages= and not freed afterwards.

This seems to say that hugepages are required for hugepagesz to be
useful, but hugepagesz is supported on PPC, whereas hugepages is not
supported on PPC ...odd.

Should those two HW lists be the same (and sorted in the same order,
for ease of reading)?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
