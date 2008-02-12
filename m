Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYBLIBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYBLIBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYBLIBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:01:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbYBLIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:01:16 -0500
Date: Mon, 11 Feb 2008 23:59:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       anton@samba.org, paulus@samba.org, rusty@rustcorp.com.au
Subject: Re: [BUID_FAILURE] regression from 2.6.24-git18 to 2.6.25-rc1-git1
 on section type conflict psmouse-base
Message-Id: <20080211235929.791f7afb.akpm@linux-foundation.org>
In-Reply-To: <47B14D52.6050404@linux.vnet.ibm.com>
References: <47B14D52.6050404@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 13:10:02 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> This build failure is seen on the powerpc from the 2.6.24-git18 kernel and is still visible
> in the 2.6.25-rc1-git1.
> 
> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
> make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
> make[2]: *** [drivers/input/mouse] Error 2
> make[1]: *** [drivers/input] Error 2
> 
> The patch http://lkml.org/lkml/2008/2/8/514 seems to have not taken into 2.6.25-rc1 and 
> 2.6.25-rc1-git(s). Is there any new patch i am missing out.

I have it queued up, along with quite a few other things, but for the next
couple of days I have logistical problems which are preventing me from
doing runtime testing.
