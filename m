Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYDJA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYDJA3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYDJA3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:29:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45525 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753096AbYDJA3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:29:04 -0400
Date: Wed, 9 Apr 2008 19:29:01 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
Message-Id: <20080409192901.a074dc35.pj@sgi.com>
In-Reply-To: <36ca99e90804091039v6e1ad966yd738ed88b267f315@mail.gmail.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184302.113424000@polaris-admin.engr.sgi.com>
	<36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
	<47FBDB0D.1010202@sgi.com>
	<36ca99e90804091039v6e1ad966yd738ed88b267f315@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert wrote:
> PS: this is the only source I found for the libbitmask(3):

Mike has been mentioning libbitmask as if it were readily
available outside SGI.  That's not entirely true, yet.

SGI delivers libbitmask as part of its products to its
customers under an LGPL license, and I provide libbitmask
sources to others on request.  Real Soon Now (tm) I will
be publishing libbitmask sources on our oss.sgi.com web
site for one and all to make use of, under LGPL license.
But I haven't done that ... yet.

Libbitmask is a user level library, similar in purpose to,
but quite different in internal implementation and API
details from, the bitmap, cpumask and nodemask types in
the kernel.

A second library, libcpuset, is also delivered by SGI under
LGPL license, and provides a rich C library for use by
major applications requiring a robust cpuset interface.
This library too should become more easily obtained, once
I get around to publishing it on oss.sgi.com.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
