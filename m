Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYC1Ng0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYC1Ng0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYC1NgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:36:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39344 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109AbYC1NgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:36:18 -0400
Date: Fri, 28 Mar 2008 08:36:13 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct
 setup_data to boot protocol
Message-Id: <20080328083613.f058172f.pj@sgi.com>
In-Reply-To: <86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
References: <1206672578.13404.21.camel@caritas-dev.intel.com>
	<86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH wrote:
> interesting, that 512nodes/4096 box physics memory is not continuous?

If each node board is stuffed with the same amount of RAM,
and that amount of RAM is a power of two size, then you
are correct that it would be continuous.

But if the nodes are stuffed with unequal amounts of RAM,
or if its not a power of two, then, because we are doing
what Andi figures (breaking the addr into bit fields, for
efficient implementation) then we can end up with many holes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
