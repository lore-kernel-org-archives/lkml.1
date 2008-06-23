Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYFWLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYFWLJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYFWLJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:09:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751629AbYFWLJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:09:43 -0400
Date: Mon, 23 Jun 2008 06:09:39 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080623060939.6b6b3183.pj@sgi.com>
In-Reply-To: <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> we should remove 0x,

I see some kernel hex prints either way, with or without, 0x.

In this case, in part because I was changing a decimal to a hex
format, and because it could be ambiguous (a hex number that
happened to use only [0-9] digits would be indistinguisable from
a decimal) I preferred using the 0x.

I see no clear answer here ... it seems to be a matter of taste.

> we should ... hex print out all the way...regarding mem pfn and
> memory address, memory size etc. except XXXMB. XXXKB...

I fixed the ones I noticed.  If you see print formats that you
would like to change, I will likely be in agreement to such a
patch.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
