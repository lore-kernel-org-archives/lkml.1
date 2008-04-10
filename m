Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYDJODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYDJODn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYDJODf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:03:35 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39238 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755516AbYDJODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:03:34 -0400
Date: Thu, 10 Apr 2008 09:03:31 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo
 v3
Message-Id: <20080410090331.da1900c5.pj@sgi.com>
In-Reply-To: <47FBD915.7020809@sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.842103000@polaris-admin.engr.sgi.com>
	<36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
	<47FBD915.7020809@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, in response to a suggestion from Bert, wrote:
> I have to subvert the cpumask interface a bit, but the resultant
> code size is about 7 instructions smaller.

I should have read ahead to this discussion, before responding
a minute ago with my suggestion using:

  typedef enum { print_as_mask, print_as_list } map_printer_t;

I slightly dislike the subversion of the cpumask interface,
and slightly -do- like the 7 instructions saved.

Either of these variants (my typedef or Berts function pointer)
would be fine by me, as you prefer, Mike.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
