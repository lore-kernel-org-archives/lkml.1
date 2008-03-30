Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbYC3EZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbYC3EZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 00:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYC3EZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 00:25:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35561 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbYC3EZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 00:25:16 -0400
Date: Sat, 29 Mar 2008 23:25:10 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
 setup_data
Message-Id: <20080329232510.b6d5e396.pj@sgi.com>
In-Reply-To: <1206672584.13404.25.camel@caritas-dev.intel.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> +	__u32	payload_offset;
> +	__u32	payload_length;

This seems to be the descriptor for an incoming compressed
kernel image, right?  What is it doing in this patchset?

In your PATCH 4/4 to Documentation/i386/boot.txt, I can see
that there already existed documentation of these two payload
fields:

 0248/4	2.08+	payload_offset	Offset of kernel payload
 024C/4	2.08+	payload_length	Length of kernel payload

However, that documentation is just a useless rephrasing of the
variable names, with the added word "kernel".  Is this a compressed
kernel image?  If so, could that documentation be improved, perhaps as:

 0248/4	2.08+	payload_offset	Offset of compressed kernel payload
 024C/4	2.08+	payload_length	Length of compressed kernel payload

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
