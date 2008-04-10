Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYDJRgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYDJRgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYDJRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:36:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46533 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756703AbYDJRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:36:06 -0400
Date: Thu, 10 Apr 2008 12:36:02 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo
 v3
Message-Id: <20080410123602.2b01f5d1.pj@sgi.com>
In-Reply-To: <36ca99e90804101024y1f159b08ucaa52eab0bea6b88@mail.gmail.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.842103000@polaris-admin.engr.sgi.com>
	<36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
	<47FBD915.7020809@sgi.com>
	<36ca99e90804101024y1f159b08ucaa52eab0bea6b88@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert wrote:
> I think its easier to count the commas from a cpumask file. 

My user level code determines NR_CPUS and MAX_NUMNODES from 32/9 times
the strlen() of the values of the Cpus_allowed and Mems_allowed fields
in /proc/self/status (being careful to -include- the trailing newline
in the strlen.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
