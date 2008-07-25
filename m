Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYGYB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYGYB0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYGYB0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:26:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39207 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751932AbYGYB0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:26:42 -0400
Date: Thu, 24 Jul 2008 20:26:34 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, hpa@zytor.com, steiner@sgi.com,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, kernel@wantstofly.org, davej@codemonkey.org.uk,
       tony.luck@intel.com, tigran@aivazian.fsnet.co.uk, paulus@samba.org,
       benh@kernel.crashing.org, robert.richter@amd.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, sammy@sammy.net,
       gnb@sgi.com, ebiederm@xmission.com, bunk@kernel.org, tglx@linutronix.de,
       schwab@suse.de, hannes@saeurebad.de
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use
 cpumask_of_cpu_map
Message-Id: <20080724202634.bc1bcc86.pj@sgi.com>
In-Reply-To: <48891DDF.7090903@sgi.com>
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>
	<20080723171841.997896000@polaris-admin.engr.sgi.com>
	<36ca99e90807240556j6b409a03s239d781baaadbb99@mail.gmail.com>
	<4888B89E.9010708@sgi.com>
	<48891DDF.7090903@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> the bit layout

See the comments near the top of lib/bitmap.c, ending with
the following lines, for documentation of the bitmap layout.

 * The byte ordering of bitmaps is more natural on little
 * endian architectures.  See the big-endian headers
 * include/asm-ppc64/bitops.h and include/asm-s390/bitops.h
 * for the best explanations of this ordering.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
