Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYDBRhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYDBRhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYDBRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:37:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41462 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754750AbYDBRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:36:59 -0400
Date: Wed, 2 Apr 2008 12:36:55 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ying.huang@intel.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
 setup_data
Message-Id: <20080402123655.2e316352.pj@sgi.com>
In-Reply-To: <47F3B6B6.9010802@zytor.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
	<20080329233155.ee909a04.pj@sgi.com>
	<1206924877.21451.6.camel@caritas-dev.intel.com>
	<20080402023947.d4d43f7d.pj@sgi.com>
	<47F3B6B6.9010802@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa wrote:
> It is usually handy to have an ID to use as ignore, or not present, and 
> for that to be zero.

Sometimes handy - if needed for specific reasons.

But many enumerations (enum or #define constants) in
the kernel have no such NONE/ignore/not-present value.

What's the use here?  I see no use for it.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
