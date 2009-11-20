Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZKTUAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZKTUAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZKTUAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZKTUAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:00:51 -0500
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org, john.johansen@canonical.com
In-Reply-To: <20091120115016.82d01eaa.akpm@linux-foundation.org>
References: <20091120094217.b94d99bb.akpm@linux-foundation.org>
	 <20091117141314.0238a49b.akpm@linux-foundation.org>
	 <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	 <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	 <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com> <6207.1255706090@redhat.com>
	 <23382.1255707790@redhat.com>
	 <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
	 <16299.1258729209@redhat.com> <18122.1258739664@redhat.com>
	 <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>
	 <20091120115016.82d01eaa.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 14:58:52 -0500
Message-Id: <1258747132.2916.15.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 11:50 -0800, Andrew Morton wrote:
> On Fri, 20 Nov 2009 14:32:02 -0500

> >     security: do not check mmap_min_addr on nommu systems
> >     
> >     nommu systems can do anything with memory they please and so they already
> >     win.  mmap_min_addr is the least of their worries.  Currently the
> >     mmap_min_addr implementation is problamatic on such systems.  This patch
> >     changes the addr_only argument to be a flags which can take the arguments
> >     for addr_only or not_addr.  LSMs then need to properly implement these two
> >     flags.
> >     
> >     Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Patch doesn't apply to current mainline for some reason.  I fixed that
> up and checked that the affected files compile OK on superh.

It was against my linux-next devel tree, probably something new in
James' for-next tree.  Are people hoping for this in stable or should we
just queue for -next?  This is a pretty old bug I guess people are just
hitting for the first time...

> The patch adds trailing whitespace.  If only we had a tool for that ;)

Fixed.

