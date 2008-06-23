Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYFWGxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYFWGxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 02:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFWGxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:53:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320AbYFWGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:53:30 -0400
Date: Mon, 23 Jun 2008 01:53:26 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
 via linked list of setup data
Message-Id: <20080623015326.bec9a75d.pj@sgi.com>
In-Reply-To: <1214200441.25753.5.camel@caritas-dev.intel.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	<20080618114511.GB28838@elte.hu>
	<1214200441.25753.5.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> With this patch, your previous patch:
> 
> x86 boot: add code to add BIOS provided EFI memory entries to kernel
> 
> is not necessary, so can be reversed.
> 
> What do you think about that?

... the same thing I thought about it when you asked this question
last month, in post http://lkml.org/lkml/2008/5/26/307.

Please see my reply in http://lkml.org/lkml/2008/5/28/59.
It was lengthy and carefully researched, so I won't repeat
it here.

In short, we still need it.  The key kernel routine that adds
additional EFI entries to the existing E820 map is just 20 or so
fairly easy lines.  We agree that it doesn't handle some of what your
more extended work with a linked list of setup data handles (such as
additional EDD entries), but it does handle additional memory map
(node) entries using the existing data structure interface between
the firmware and kernel.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
