Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZGOJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZGOJZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZGOJZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:25:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51886 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZGOJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:25:14 -0400
Date: Wed, 15 Jul 2009 18:24:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
Message-ID: <20090715092446.GB1863@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Bryan Wu <cooloney@kernel.org>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> <20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6206.1247592126@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 06:22:06PM +0100, David Howells wrote:
> Mike Frysinger <vapier@gentoo.org> wrote:
> 
> > Some architectures (like the Blackfin arch) implement some of the
> > "simpler" features that one would expect out of a MMU such as memory
> > protection.  In our case, we actually get read/write/exec protection
> > down to the page boundary so processes can't stomp on each other let
> > alone the kernel.  There is a performance decrease (which depends greatly
> > on the workload) however as the hardware/software interaction was not
> > optimized at design time.
> 
> It occurs to me that I could probably test this on FRV by using the MMU in a
> limited way.  How do you actually keep track of the protections applied?  Do
> you have a single global page table that is managed by the mmap code on a
> per-VMA basis?
> 
SH can do this as well for the single-address-space mode in the MMU, but
in that case I would still use a global page table.
